# uses the Twitter Search API to find messages to @watchmemake 

# ENV['RAILS_ENV'] = 'development'
require File.expand_path('../../config/environment',  __FILE__)
                                      
next_search_url = 'http://search.twitter.com/search.json?q=to%3Awatchmemake'

data = JSON.parse(HTTParty.get(next_search_url).body)
tweets = data['results'].collect { |tweet| tweet['text'] }
urls = tweets.collect do |tweet|
  tweet.match(/http.*?( |$)/)[0]
end

urls.each do |url|
  case url
  when /twitpic/
    image = Twimage::Twitpic.new(url)
  when /yfrog/
    image = Twimage::Yfrog.new(url)
  else
    raise StandardError, "Service parser for #{url} not found"
  end
  
  Image.create :build_id => 1, :file => image

end
