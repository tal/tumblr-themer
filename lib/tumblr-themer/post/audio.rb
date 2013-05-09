class TumblrThemer::Post::Audio < TumblrThemer::Post

  def embed_size size
    data['embed'].gsub(/width=['"](\d+)['"]/,%Q{width="#{size}"})
  end

  block_tag('Caption')

  block('AudioEmbed', 'embed')
  [250,400,500,640].each do |size|
    tag("AudioEmbed-#{size}") { embed_size(size) }
  end
  tag("AudioEmbed") { embed_size(500) }

  block('AudioPlayer','player')
  %w{AudioPlayer AudioPlayerWhite AudioPlayerGrey AudioPlayerBlack}.each do |t|
    tag(t,'player')
  end

  block_tag('PlayCount','plays')
  tag('FormattedPlayCount') { data['plays'].to_s.reverse.gsub(/...(?=.)/,'\&,').reverse }
  tag('PlayCountWithLabel') do
    num = data['plays']
    str = num.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    str << (num == 1 ? 'play' : 'plays')
  end

  block('AlbumArt', 'album_art')
  tag('AlbumArtURL', 'album_art')

  block_tag('Artist')
  block_tag('Album')
  block_tag('TrackName')

end
