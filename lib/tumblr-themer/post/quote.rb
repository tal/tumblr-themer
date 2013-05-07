class TumblrThemer::Post::Quote < TumblrThemer::Post
  tag('Quote') { data['text'] }

  block('Source') { boolify(data['source']) }
  tag('Source')   { data['source'] }

  tag 'Length' do
    %w{short medium long}[rand(3)]
  end
end
