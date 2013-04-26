class TumblrThemer::Post::Link < TumblrThemer::Post
  tag('URL') { data['url'] }
  tag('Name'){ data['title'] }
  tag('target') { 'target="_blank"' }
  block('Description') { boolify(data['description']) }
  tag('Description') { data['description'] }
end
