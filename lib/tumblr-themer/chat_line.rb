class TumblrThemer::ChatLine
  include TumblrThemer::TagHelper
  attr_reader :html, :data, :line_index

  def initialize html, data, index=0
    @html = TumblrThemer::HtmlSnippet.new(html.dup) if html
    @data = data.dup
    @line_index = index
  end

  tag('Alt') { line_index%2==0 ? 'odd' : 'even' }

  block('Label') { boolify(data['label']) }
  tag('Label') { data['label'] }

  tag('UserNumber') { line_index }
  tag('Name') { data['name'] }
  tag('Line') { data['phrase'] }
end
