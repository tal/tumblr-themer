module TumblrThemer::API
  extend self
  attr_writer :base_hostname, :api_key

  def base_hostname
    name = @base_hostname || settings['blog']
    if name =~ /tumblr\.com/
      name
    else
      "#{name}.tumblr.com"
    end
  end

  def settings
    YAML.load_file('./tumblr-theme.yml')
  end

  def api_key
    @api_key ||= settings['api_key']
  end

  def posts
    all_posts['response']
  end

  def selected_posts
    blog = nil
    posts = []
    settings['posts'].each do |id|
      data = all_posts(id: id)
      posts << data['response']['posts'].first
      blog ||= data['response']['blog']
    end

    {
      'posts' => posts,
      'blog' => blog
    }
  end

  def all_posts(params={})
    url = URL.new("http://api.tumblr.com/v2/blog/#{base_hostname}/posts")
    url[:api_key] = api_key
    url[:reblog_info] = true
    url[:id] = params[:id] if params[:id]
    url.get.json
  end
end
