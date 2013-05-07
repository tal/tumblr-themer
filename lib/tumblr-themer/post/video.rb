class TumblrThemer::Post::Video < TumblrThemer::Post
  def player
    data['player']||[{}]
  end

  def video_size size
    (player.find {|p| p['width'] == size}||player.first)['embed_code']
  end

  block('Caption') { boolify(data['caption']) }
  tag('Caption') { data['caption'] }

  [700,500,400,250].each do |size|
    tag("Video-#{size}")      { video_size(size) }
    tag("VideoEmbed-#{size}") { video_size(size) }
  end

  tag('PlayCount') { rand(90000) }
  tag('FormattedPlayCount') { rand(90000).to_s.reverse.gsub(/...(?=.)/,'\&,').reverse }
  tag('PlayCountWithLabel') do
    num = rand(90000)
    str = num.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
    str << (num == 1 ? 'play' : 'plays')
  end

end
