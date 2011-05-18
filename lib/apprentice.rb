# Uses the Twitter Search API to find messages to @watchmemake 
# see script/apprentice to run this script

# ENV['RAILS_ENV'] = 'development'
require File.expand_path('../../config/environment',  __FILE__)

module WatchMeMakeThis
  
  URL_REGEX = /http.*?( |$)/
  HASHTAG_REGEX = /#([\w-]+)/
  SEARCH_URL_PREFIX = 'http://search.twitter.com/search.json'
  
  class Apprentice
    
    @@log = Logger.new(Rails.root.join('log','apprentice.log'))
    
    def self.run
      @@log.info "Apprentice starting at #{Time.zone.now}..."
      next_search_url = System.first.next_twitter_call
      
      until next_search_url.nil?

        data = JSON.parse(HTTParty.get(next_search_url).body)
        tweets = data['results'].collect do |result| 
          id = result['id_str']
          from = result['from_user']
          url = result['text'].match(URL_REGEX)[0] if result['text'].match(URL_REGEX)
          hashtag = result['text'].match(HASHTAG_REGEX)[1] if result['text'].match(HASHTAG_REGEX)
          description = result['text'].gsub(System.first.twitter_username || /@[\w]+/, '').gsub(url, '').gsub('#'+hashtag, '').strip if url and hashtag
          { :id => id, :from => result['from_user'], :url => url, :hashtag => hashtag, :description => description }
        end
      
        @@log.info "  #{tweets.size} new tweets found, page #{data['page']}"

        if tweets.any?
          tweets.each do |tweet|
            @@log.info "    #{tweet.inspect}"
            if validate(tweet)
              begin
                # get the image from the proper service
                # case tweet[:url]
                # when /twitpic/
                #   image = Twimage::Twitpic.new(tweet[:url])
                #   System.first.increment!(:twitpic_count)
                # when /yfrog/
                #   image = Twimage::Yfrog.new(tweet[:url])
                #   System.first.increment!(:yfrog_count)
                # else
                #   raise StandardError, "Service parser for #{url} not found"
                # end
                
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
                @@log.error %Q{      #{e.message}}
              end
            else
              @@log.info "      Invalid tweet, skipping"
            end
          end
        end
        
        # if there are multiple pages of results, get the next page
        next_search_url = data['next_page'] ? SEARCH_URL_PREFIX + data['next_page'] : nil

      end # until
  
      # finally, update the system with the next API call
      System.first.update_attributes :next_twitter_call => SEARCH_URL_PREFIX + data['refresh_url']
      
      @@log.info "  Done."
    end
    
    # validate that a tweet has all the required info
    def self.validate(tweet)
      if tweet[:url].nil?
        @@log.info "      URL not found."
        return false
      elsif tweet[:hashtag].nil?
        @@log.info "      Hashtag not found."
        return false
      end
      return true
    end
    
  end
end
