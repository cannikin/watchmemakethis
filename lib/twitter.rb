# uses the Twitter Search API to find messages to @watchmemake 

# ENV['RAILS_ENV'] = 'development'
require File.expand_path('../../config/environment',  __FILE__)
                                      
next_search_url = System.first.next_twitter_call

data = JSON.parse(HTTParty.get(next_search_url).body)
tweets = data['results'].collect do |result| 
  { :from => result['from_user'], :url => result['text'].match(/http.*?( |$)/)[0], :hashtag => result['text'].match(/#([\w-]+)/)[1] }
end

if tweets.any?
  tweets.each do |tweet|
    begin
      # get the image from the proper service
      case tweet[:url]
      when /twitpic/
        image = Twimage::Twitpic.new(tweet[:url])
        System.first.increment!(:twitpic_count)
      when /yfrog/
        image = Twimage::Yfrog.new(tweet[:url])
        System.first.increment!(:yfrog_count)
      else
        raise StandardError, "Service parser for #{url} not found"
      end
  
      # find the appropriate user/build to assign this image to
      if user = User.find_by_twitter(tweet[:from])
        if build = user.builds.find_by_hashtag(tweet[:hashtag])
          Image.create!(:build_id => build.id, :file => image)
        else
          raise StandardError, "User #{user.email} has no build with hashtag ##{tweet[:hashtag]}"
        end
      else
        raise StandardError, "No user with twitter username '#{tweet[:from]}' found"
      end
    rescue StandardError => e
      puts e.message
    end
  end
end
  
# finally, update the system with the next API call
System.first.update_attributes :next_twitter_call => "http://search.twitter.com/search.json#{data['refresh_url']}"
