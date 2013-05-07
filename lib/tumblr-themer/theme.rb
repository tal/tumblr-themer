class TumblrThemer::Theme
  include TumblrThemer::TagHelper
  attr_reader :body

  def initialize dirname
    base = File.expand_path(dirname)

    @body = File.read(File.join(base,'index.html'))
    @posts = {}
    Dir[File.join(base,'posts/*.html')].each do |f|
      basename = File.basename(f).sub(/\.html$/,'').gsub(/[_-]/,' ')
      html = File.read(f)
      @posts[basename] = html
    end

    posts_html = @posts.collect do |basename, html|
      str = "{block:#{basename.capitalize}}"
      str << html
      str << "{/block:#{basename.capitalize}}"
    end

    @body.gsub!("{PostsCode}",posts_html.join("\n"))
  end

  def get_data
    return @post_data if defined?(@post_data)
    data = TumblrThemer::API.selected_posts
    @blog_data = data['blog']
    @post_data = data['posts']
  end

  def post_data
    @post_data || (get_data && @post_data)
  end

  def blog_data
    @blog_data || (get_data && @blog_data)
  end

  def render
    html = TumblrThemer::HtmlSnippet.new(@body)

    self.class.tag_iterators.each do |name, opts|
      vals = instance_exec(self,&opts[:blk])
      html.block(name) do |str|
        vals.collect.with_index do |val,i|
          opts[:klass].render(str,val,i)
        end.join("\n")
      end
    end

    self.class.blocks.each do |name,blk|
      html.block(name,instance_exec(self,&blk))
    end

    self.class.tags.each do |name, blk|
      html.tag(name,instance_exec(self,&blk))
    end

    html.str
  end

  for_each('Posts',TumblrThemer::Post) { post_data }

  tag('Title') { blog_data['title'] }
  tag('Description') { blog_data['description'] }
  tag('CopyrightYears') {'2007-2013'}
  tag('CustomCSS') {''}

  # block('IndexPage') { true }
  # block('PermalinkPage') { false }
  # block('PostTitle') { false }
  # tag('PostTitle') {''}
  # block('PostSummary') { false }
  # tag('PostSummary') {''}

  block('Date') { false }
end
