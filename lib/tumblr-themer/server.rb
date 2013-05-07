require 'sinatra/base'

class TumblrThemer::Server < Sinatra::Base
  get '/' do
    theme = TumblrThemer::Theme.new('.')

    theme.render
  end

  get '/post/:id' do
    theme = TumblrThemer::Theme.new('.')
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
