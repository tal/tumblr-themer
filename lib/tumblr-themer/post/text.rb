class TumblrThemer::Post::Text < TumblrThemer::Post
  block('Title') { boolify(data['title']) }
  tag('Title')   { data['title'] }
  tag('Body')    { data['body'] }
end
