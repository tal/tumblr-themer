module TumblrThemer::API
  extend self
  attr_accessor :blog_url, :api_key

  def posts
    url = URL.new("http://api.tumblr.com/v2/blog/#{blog_url}/posts")
    url[:api_key] = api_key
    url[:reblog_info] = true
    url.get.json
  end
end

TumblrThemer::API.blog_url ='talby.tumblr.com'
TumblrThemer::API.api_key = ''
