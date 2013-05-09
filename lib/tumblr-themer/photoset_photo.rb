class TumblrThemer::PhotosetPhoto
  include TumblrThemer::TagHelper
  attr_reader :html, :data

  def initialize html, data, i=0
    @html = TumblrThemer::HtmlSnippet.new(html.dup) if html
    @data = data.dup
  end

  def photo_size size
    data.find {|p| p['width'] == size}||data.first
  end

  [500,400,250,100].each do |size|
    tag("PhotoURL-#{size}") { photo_size(size)['url'] }
    tag("PhotoWidth-#{size}") { photo_size(size)['width'] }
    tag("PhotoHeight-#{size}") { photo_size(size)['height'] }
  end
  tag("PhotoURL-75sq") { photo_size(75)['url'] }
end
