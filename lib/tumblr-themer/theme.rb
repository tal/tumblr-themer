class TumblrThemer::Theme
  include TumblrThemer::TagHelper

  POST_TYPES = %w{
    text
    photo
    panorama
    photoset
    quote
    link
    chat
    audio
    video
    answer
  }

  def initialize dirname
    base = File.expand_path(dirname)

    @body = File.read(File.join(base,'index.html'))
    @posts = {}
    posts = Dir[File.join(base,'posts/*.html')].collect do |f|
      basename = File.basename(f).sub(/\.html$/,'').gsub(/[_-]/,' ').capitalize
      html = File.read(f)
      @posts[basename.downcase] = TumblrThemer::HtmlSnippet.new(html)

      str = "{block:#{basename}}"
      str << html
      str << "{/block:#{basename}}"
    end

    # posts.unshift "{block:Posts}"
    # posts.push    "{/block:Posts}"

    # @body.sub!('{block:Posts/}',posts.join("\n"))
  end

  def post type
    str = @body
    block(str,'posts',true)

    POST_TYPES.each do |_type|
      block(str,_type,type==_type)
    end

    str
  end

  attr_reader :blog_data
  def render
    data = TumblrThemer::API.posts['response']
    post_data = data['posts']
    @blog_data = data['blog']

    posts = []
    post_data.each_with_index do |post_datum,i|
      begin
        klass = TumblrThemer::Post.const_get(post_datum['type'].capitalize)
        posts << klass.new(@posts[post_datum['type']],post_datum,i)
      rescue NameError
      end
    end

    html = TumblrThemer::HtmlSnippet.new(@body.sub('{block:Posts/}',posts.collect(&:render).join("\n")))

    self.class.blocks.each do |name,blk|
      html.block(name,instance_exec(self,&blk))
    end

    self.class.tags.each do |name, blk|
      html.tag(name,instance_exec(self,&blk))
    end

    html.str
  end

  tag('Title') { blog_data['title'] }
  tag('Description') { blog_data['description'] }
  tag('CopyrightYears') {'2007-2013'}
  tag('CustomCSS') {''}

  block('IndexPage') { true }
  block('PermalinkPage') { false }
  block('PostTitle') { false }
  tag('PostTitle') {''}
  block('PostSummary') { false }
  tag('PostSummary') {''}
end
