class TumblrThemer::Post::Photo < TumblrThemer::Post
  def photo
    data['photos'].first['alt_sizes']
  end

  def photo_size size
    photo.find {|p| p['width'] == size}||photo.first
  end

  def exif
    data['photos'].first['exif'] || {}
  end

  def exif?
    boolify(exif)
  end

  tag('PhotoAlt') { 'alt photo' }

  block('Caption') { boolify(data['caption']) }
  tag('Caption')   { data['caption'] }

  block('LinkURL')    { boolify(data['link_url']) }
  tag('LinkURL')      { data['link_url'] }
  tag('LinkOpenTag')  { %Q[<a href="#{data['link_url']}">]}
  tag('LinkCloseTag') { '</a>' }

  [500,400,250,100].each do |size|
    tag("PhotoURL-#{size}") do
      photo_size(size)['url']
    end
    tag("PhotoWidth-#{size}") { photo_size(size)['width'] }
    tag("PhotoHeight-#{size}") { photo_size(size)['height'] }
  end
  tag("PhotoURL-75sq") { photo_size(75)['url'] }

  block('HighRes') { false }

  block("Exif") { exif? }
  block("Camera") { exif? && boolify(exif['Camera'])}
  tag("Camera") { exif['Camera'] }
  block("Aperture") { exif? && boolify(exif['Aperture'])}
  tag("Aperture") { exif['Aperture'] }
  block("Exposure") { exif? && boolify(exif['Exposure'])}
  tag("Exposure") { exif['Exposure'] }
  block("FocalLength") { exif? && boolify(exif['FocalLength'])}
  tag("FocalLength") { exif['FocalLength'] }
  block("ISO") { exif? && boolify(exif['ISO'])}
  tag("ISO") { exif['ISO'] }
end
