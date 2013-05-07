class TumblrThemer::Post::Photoset < TumblrThemer::Post::Photo
  [700,500,400,250].each do |size|
    tag("Photoset-#{size}") { %Q[<img src="http://placekitten.com/#{size}/#{(size*(rand+1)).to_i}" width="#{size}"/>] }
  end
  tag("PhotoCount") { data['photos'].size }
  tag("PostType") { 'photoset' }
end
