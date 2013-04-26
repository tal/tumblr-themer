class TumblrThemer::Post::Photo < TumblrThemer::Post
  def photo
    data['photos'].first['alt_sizes']
  end

  def photo_size size
    photo.find {|p| p['width'] == size}
  end

  def exif?
    boolify(photo&&photo['exif'])
  end

  tag('PhotoAlt') { 'alt photo' }

  block('Caption') { boolify(data['caption']) }
  tag('Caption')   { data['caption'] }

  block('LinkURL')    { boolify(data['link_url']) }
  tag('LinkURL')      { data['link_url'] }
  tag('LinkOpenTag')  { %Q[<a href="#{data['link_url']}">]}
  tag('LinkCloseTag') { '</a>' }

  [500,400,250,100].each do |size|
    tag("PhotoURL-#{size}") { photo_size(size)['url'] }
    tag("PhotoWidth-#{size}") { photo_size(size)['width'] }
    tag("PhotoHeight-#{size}") { photo_size(size)['height'] }
  end
  tag("PhotoURL-75sq") { photo_size(75)['url'] }

  block('HighRes') { false }

  block("Exif") { exif? }
  block("Camera") { exif? && boolify(photo['exif']['Camera'])}
  tag("Camera") { photo['exif']['Camera'] }
  block("Aperture") { exif? && boolify(photo['exif']['Aperture'])}
  tag("Aperture") { photo['exif']['Aperture'] }
  block("Exposure") { exif? && boolify(photo['exif']['Exposure'])}
  tag("Exposure") { photo['exif']['Exposure'] }
  block("FocalLength") { exif? && boolify(photo['exif']['FocalLength'])}
  tag("FocalLength") { photo['exif']['FocalLength'] }
  block("ISO") { exif? && boolify(photo['exif']['ISO'])}
  tag("ISO") { photo['exif']['ISO'] }
end
