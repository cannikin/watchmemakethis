# Uses the Twitter Search API to find messages to @watchmemake 
# Use script/apprentice to daemonize this script:
#
#   script/apprentice start -- production 30
#
# Where the first argument after the -- is the environment and 
# the second is the number of seconds to wait between API calls

if ARGV.length == 0
  puts 'Usage: script/apprentice start -- [environment] [seconds_interval]'
  exit 0
end

ENV['RAILS_ENV'] = ARGV[0] || 'development'
require File.expand_path('../../config/environment',  __FILE__)

module WatchMeMakeThis
  
  module Apprentice
    
    LOGGER = Logger.new(Rails.root.join('log','apprentice.log'))
    LOGGER.info "Apprentice starting at #{Time.zone.now}..."
    
    class Twitter
      
      URL_REGEX = /http.*?( |$)/
      HASHTAG_REGEX = /#([\w-]+)/
      SEARCH_URL_PREFIX = 'http://search.twitter.com/search.json'
      USER_AGENT = 'WatchMeMake.com Twitter Search'
      
      def self.run
        
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
      
          LOGGER.info "  #{tweets.size} new tweets found, page #{data['page']}"

          if tweets.any?
            tweets.each do |tweet|
              LOGGER.info "    #{tweet.inspect}"
              if validate(tweet)
                begin
                  image = Twimage.get(tweet[:url])
  
                  # find the appropriate user/build to assign this image to
                  if user = User.find_by_twitter(tweet[:from])
                    if build = user.builds.find_by_hashtag(tweet[:hashtag])
                      Image.create!(:build_id => build.id, :file => image, :tweet_id => tweet[:id], :description => tweet[:description])
                      image.tempfile.unlink
                    else
                      raise StandardError, "User #{user.email} has no build with hashtag ##{tweet[:hashtag]}"
                    end
                  else
                    raise StandardError, "No user with twitter username '#{tweet[:from]}' found"
                  end
                rescue => e
                  LOGGER.error %Q{      #{e.message}}
                end
              else
                LOGGER.info "      Invalid tweet, skipping"
              end
            end
          end
        
          # if there are multiple pages of results, get the next page
          next_search_url = data['next_page'] ? SEARCH_URL_PREFIX + data['next_page'] : nil

        end # until
  
        # finally, update the system with the next API call
        System.first.update_attributes :next_twitter_call => SEARCH_URL_PREFIX + data['refresh_url']
      
        LOGGER.info "  Done."
      end
    
      # validate that a tweet has all the required info
      def self.validate(tweet)
        if tweet[:url].nil?
          LOGGER.info "      URL not found."
          return false
        elsif tweet[:hashtag].nil?
          LOGGER.info "      Hashtag not found."
          return false
        end
        return true
      end
    
    end
    
    class Email
      
      @@gmail ||= Gmail.connect!('images@watchmemake.com','%Ha2h=Lm')
      
      def self.run
        
        LOGGER.info "  #{@@gmail.inbox.find(:unread).count} new emails..."
        
        emails = @@gmail.inbox.find(:unread)
        emails.each do |email|
          from = email.from.first.mailbox + '@' + email.from.first.host
          if User.find_by_email(from)
            hashtag = email.subject.gsub('#','')
            if hashtag.present? and build = Build.find_by_hashtag(hashtag)
              description = email.text_part.body.to_s.strip
              if email.attachments.any?
                email.attachments.each do |attachment|
                  image = TempImage.new(attachment.body, attachment.content_type.split('/').last)
                  Image.create!(:build_id => build.id, :file => image, :description => description)
                  image.tempfile.unlink
                end
              else
                raise StandardError, 'No images were attached to this email'
              end
            else
              raise StandardError, "User #{user.email} has no build with hashtag ##{tweet[:hashtag]}"
            end
          else
            raise StandardError, "No user with email address '#{from}' found"
          end
        end
        LOGGER.info "  Done."
      end
      
      
      class TempImage
        attr_accessor :tempfile
        def initialize(body, type)
          @tempfile = Tempfile.new(["watchmemake",".#{type}"])
          @tempfile.write(body.to_s.force_encoding('utf-8'))
        end
      end
      
    end
    
  end
end

loop do
  WatchMeMakeThis::Apprentice::Twitter.run
  WatchMeMakeThis::Apprentice::Email.run
  sleep ARGV[1].to_i > 0 ? ARGV[1].to_i : 60
end
