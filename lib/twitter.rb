# uses the Twitter Search API to find messages to @watchmemake 

require 'httparty'
require 'json'

next_search_url = 'http://search.twitter.com/search.json?q=to%3Awatchmemake'

data = JSON.parse(HTTParty.get(next_search_url).body)
tweets = data['results'].collect { |tweet| tweet['text'] }
urls = tweets.collect do |tweet|
  tweet.match(/http.*?( |$)/)[0]
end
puts urls.inspect
