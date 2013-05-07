class TumblrThemer::Tag
  include TumblrThemer::TagHelper
  attr_reader :html, :data

  def initialize html, data
    @html = TumblrThemer::HtmlSnippet.new(html.dup) if html
    @data = data.dup
  end

  def render
    self.class.tags.each do |name, blk|
      html.tag(name,instance_exec(self,&blk))
    end

    html.str
  end

  tag('Tag')          { data }
  tag('URLSafeTag')   { data }
  tag('TagURL')       { data }
  tag('TagURLChrono') { data }
end
