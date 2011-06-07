# Uses the Twitter Search API to find messages to @watchmemake 
# Use script/apprentice to daemonize this script:
#
#   script/apprentice start -- production 30
#
# Where the first argument after the -- is the environment and 
# the second is the number of seconds to wait between API calls

# if ARGV.length == 0
#  puts 'Usage: script/apprentice start -- [environment] [seconds_interval]'
#  exit 0
# end

require 'bundler/setup'
require 'logger'

ENV['RAILS_ENV'] = ARGV[0] || 'development'
ROOT = File.join(File.expand_path(File.dirname(__FILE__)), '..')
LOGGER = Logger.new(File.join(ROOT, 'log', 'apprentice.log'))
DB_CONFIG = YAML.load(File.read(File.join(ROOT, 'config', 'database.yml')))[ENV['RAILS_ENV']]
DB_CONFIG.merge!('database' => File.join(ROOT, DB_CONFIG['database'])) if DB_CONFIG['adapter'] == 'sqlite3'

require 'active_record'
require 'acts_as_list'
require 'gmail'
require 'twimage'
require 'aws/s3'
require 'action_mailer'
require 'aws/ses'
require 'uuid'
require 'image_science'
require_relative '../app/models/user'
require_relative '../app/models/site'
require_relative '../app/models/build'
require_relative '../app/models/upload_method'
require_relative '../app/models/image'
require_relative '../app/models/system'
require_relative '../config/initializers/aws'

# simulated Rails object so Rails.logger still works
class Rails
  def self.logger
    LOGGER
  end
end

module WatchMeMakeThis
  
  module Apprentice
    
    HASHTAG_REGEX = /#([\w-]+)/
    
    LOGGER.info "Apprentice starting at #{Time.now}."
    
    ActiveRecord::Base.establish_connection(DB_CONFIG)
    
    class Twitter
      
      URL_REGEX = /http.*?( |$)/
      SEARCH_URL_PREFIX = 'http://search.twitter.com/search.json'
      USER_AGENT = 'WatchMeMake.com Twitter Search'
      
      def self.run
        
        LOGGER.info "  Twitter search starting at #{Time.now}"
        
        next_search_url = System.first.next_twitter_call
      
        until next_search_url.nil?

          data = JSON.parse(HTTParty.get(next_search_url, :headers => { 'User-Agent' => USER_AGENT}).body)
          tweets = data['results'].collect do |result| 
            id = result['id_str']
            from = result['from_user']
            url = result['text'].match(URL_REGEX)[0] if result['text'].match(URL_REGEX)
            hashtag = result['text'].match(HASHTAG_REGEX)[1] if result['text'].match(HASHTAG_REGEX)
            description = result['text'].gsub(System.first.twitter_username || /@[\w]+/, '').gsub(url, '').gsub('#'+hashtag, '').strip if url and hashtag
            { :id => id, :from => result['from_user'], :url => url, :hashtag => hashtag, :description => description }
          end
      
          LOGGER.info "    #{tweets.size} new tweets found, page #{data['page']}"

          if tweets.any?
            tweets.each do |tweet|
              LOGGER.info "      #{tweet.inspect}"
              if validate(tweet)
                begin
                  image = Twimage.get(tweet[:url])
  
                  # find the appropriate user/build to assign this image to
                  if user = User.find_by_twitter(tweet[:from])
                    if build = user.builds.find_by_hashtag(tweet[:hashtag])
                      begin
                        Image.create!(:build_id => build.id, :file => image.tempfile, :tweet_id => tweet[:id], :description => tweet[:description], :upload_method_id => UploadMethod::TWITTER)
                      rescue => e
                        LOGGER.error "*** Error trying to save file: #{e.message}\n#{e.backtrace}"
                      ensure
                        image.tempfile.unlink
                      end
                    else
                      LOGGER.warn "User #{user.email} has no build with hashtag ##{tweet[:hashtag]}"
                    end
                  else
                    LOGGER.warn "No user with twitter username '#{tweet[:from]}' found"
                  end
                rescue => e
                  LOGGER.error %Q{        #{e.message}}
                end
              else
                LOGGER.info "        Invalid tweet, skipping"
              end
            end
          end
        
          # if there are multiple pages of results, get the next page
          next_search_url = data['next_page'] ? SEARCH_URL_PREFIX + data['next_page'] : nil

        end # until
  
        # finally, update the system with the next API call
        System.first.update_attributes :next_twitter_call => SEARCH_URL_PREFIX + data['refresh_url']
      
        LOGGER.info "    Done."
      end
    
      # validate that a tweet has all the required info
      def self.validate(tweet)
        if tweet[:url].nil?
          LOGGER.info "        URL not found."
          return false
        elsif tweet[:hashtag].nil?
          LOGGER.info "        Hashtag not found."
          return false
        end
        return true
      end
    
    end
    
    class Email
      
      @@gmail ||= Gmail.connect!('images@watchmemake.com','%Ha2h=Lm')
      
      def self.run
        
        LOGGER.info "  Email search starting at #{Time.now}"
        LOGGER.info "    #{@@gmail.inbox.find(:unread).count} new emails"
        
        emails = @@gmail.inbox.find(:unread)
        emails.each do |email|
          begin
            from = email.from.first.mailbox + '@' + email.from.first.host
            if user = User.find_by_email(from)
              hashtag_match = email.subject.match(HASHTAG_REGEX)
              hashtag = hashtag_match[1] if hashtag_match
              if hashtag.present? 
                if build = user.builds.find_by_hashtag(hashtag)
                  subject_description = email.subject.gsub("##{hashtag}",'').strip
                  description = subject_description.present? ? subject_description : description = email.text_part.body.to_s.strip
                  if email.attachments.any?
                    LOGGER.info "      #{email.attachments.count} new images attached"
                    email.attachments.each do |attachment|
                      tempfile = Tempfile.new(['apprentice',attachment.filename])
                      File.open(tempfile.path, "w+b") { |f| f.write attachment.body.decoded }
                      begin
                        Image.create!(:build_id => build.id, :file => tempfile, :description => description, :upload_method_id => UploadMethod::EMAIL)
                      rescue => e
                        LOGGER.error "*** Error trying to save file: #{e.message}\n#{e.backtrace}"
                      ensure
                        tempfile.unlink
                      end
                    end
                    email.delete!
                  else
                    LOGGER.warn '      No images were attached to this email'
                  end
                else
                  LOGGER.warn "      User #{from} has no build with hashtag ##{hashtag}"
                end
              else
                LOGGER.warn "      No hashtag found in the subject"
              end
            else
              LOGGER.warn "      No user with email address '#{from}' found"
            end
          rescue => e
            LOGGER.error "      Unexpected error: #{e.message}\n#{e.backtrace}"
          ensure
            email.delete!
          end
        end # looping through emails in inbox
        LOGGER.info "    Done."
      end
      
    end
    
  end
end

loop do
  WatchMeMakeThis::Apprentice::Twitter.run
  WatchMeMakeThis::Apprentice::Email.run
  #sleep 10
  sleep ARGV[1].to_i > 0 ? ARGV[1].to_i : 60
end
