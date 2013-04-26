class TumblrThemer::Post::Quote < TumblrThemer::Post
  tag 'Quote' do
    data['text']
  end

  block 'Source' do
    !!data['source']
  end

  tag 'Source' do
    data['source']
  end

  tag 'Length' do
    # case rand(3)
    #   when 0: 'short'
    #   when 1: 'medium'
    #   when 2: 'long'
    # end
  end
end
