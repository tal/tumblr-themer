class TumblrThemer::Tag
  include TumblrThemer::TagHelper
  attr_reader :html, :data

  def initialize html, data, index=0
    @html = TumblrThemer::HtmlSnippet.new(html.dup) if html
    @data = data.dup
  end

  def render
    render_tags

    html.str
  end

  tag('Tag')          { data }
  tag('URLSafeTag')   { CGI.escape(data) }
  tag('TagURL')       { '#' }
  tag('TagURLChrono') { '#' }
end
