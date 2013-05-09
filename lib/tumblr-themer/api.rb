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

  def settings dirname='.'
    file = File.expand_path("#{dirname}/tumblr-theme.yml")

    unless File.exist?(file)
      raise ConfigFileError, "#{file} not found"
    end

    data = YAML.load_file(file)
    raise ConfigFileError, "no api_key found in config file" unless data['api_key']
    data
  end

  def api_key
    @api_key ||= settings['api_key']
  end

  def posts
    if settings['posts']
      selected_posts
    else
      all_posts['response']
    end
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
    json = url.get.json
    puts json.inspect

    status = json['meta']['status']
    if status == 401
      raise ConfigFileError, "invalid api_key found in config file"
    elsif status != 200
      raise RequestError, json['meta'].inspect
    end
    json
  end

  class ConfigFileError < StandardError; end
  class RequestError < StandardError; end
end
