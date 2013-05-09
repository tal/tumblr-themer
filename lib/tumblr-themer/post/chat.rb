class TumblrThemer::Post::Chat < TumblrThemer::Post
  block('Title') { boolify(data['title']) }
  tag('Title')   { data['title'] }

  for_each('Lines',TumblrThemer::ChatLine) { data['dialogue'] }
end
