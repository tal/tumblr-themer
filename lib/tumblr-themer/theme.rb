class TumblrThemer::Theme
  include TumblrThemer::TagHelper
  attr_reader :body, :params

  def initialize dirname, params={}
    @base = File.expand_path(dirname)
    @params = params

    @body = File.read(File.join(@base,'index.html'))
    @posts = {}
    Dir[File.join(@base,'posts/*.html')].each do |f|
      basename = File.basename(f).sub(/\.html$/,'')
      html = File.read(f)
      @posts[basename] = html
    end

    posts_html = @posts.collect do |basename, html|
      str = "{block:#{camelize(basename)}}"
      str << html
      str << "{/block:#{camelize(basename)}}"
    end

    @body.gsub!("{PostsCode}",posts_html.join("\n"))

    render_partials
  end

  def get_data
    return @post_data if defined?(@post_data)
    if params[:id]
      data = TumblrThemer::API.all_posts(:id => params[:id])
    else
      data = TumblrThemer::API.posts
    end

    @blog_data = data['blog']
    @post_data = data['posts']
  end

  def post_data
    @post_data || (get_data && @post_data)
  end

  def blog_data
    @blog_data || (get_data && @blog_data)
  end

  def page
    if params[:page]
      params[:page].to_i
    else
      1
    end
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

  block('IndexPage')     { !boolify(params[:id]) }
  block('PermalinkPage') { boolify(params[:id]) }
  block('PostTitle')     { boolify(params[:id]) }
  tag('PostTitle')       { "Post Title" }
  # block('PostSummary') { false }
  # tag('PostSummary') {''}

  block('Date') { false }

  block('Pagination')   { !boolify(params[:id]) }
  block('PreviousPage') { page > 1 }
  block('NextPage')     { page < 3 }
  tag('PreviousPage')   do
    if page == 2
      '/'
    else
      "/page/#{page-1}"
    end
  end
  tag('NextPage')       { "/page/#{page+1}"}
  tag('CurrentPage')    { page }
  tag('TotalPages')     { 3 }

  block('SubmissionsEnabled') { true }
  tag('SubmitLabel')          { 'Submit' }
  block('AskEnabled')         { true }
  tag('AskLabel')             { 'Ask' }


  private

  def render_partials
    partials = {}
    Dir[File.join(@base,'partials/*.html')].each do |f|
      basename = "{partial:"<<camelize(File.basename(f).sub(/\.html$/,''))<<"}"
      html = File.read(f)
      partials[basename] = html
    end

    regex = Regexp.new("{partial:(.+?)}")
    i=0

    while match = regex.match(@body)
      if i > 5000
        raise RecusiveTag, "you probably have a recursive partial, make sure to fix that"
      else
        i += 1
      end

      if html = partials[match[0]]
        @body.gsub!(match[0],html)
      else
        raise UndefinedPartial, "Unknown partial: #{match[1]}, please place in partials/#{underscore(match[1])}.html"
      end
    end
  end

  class UndefinedPartial < StandardError; end
  class RecusiveTag < StandardError; end

end
