require 'sinatra/base'

class TumblrThemer::Server < Sinatra::Base
  get '/' do
    theme = TumblrThemer::Theme.new('.',params)

    theme.render
  end

  get '/post/:id' do
    theme = TumblrThemer::Theme.new('.',params)
    theme.render
  end

  get '/page/:page' do
    theme = TumblrThemer::Theme.new('.',params)
    theme.render
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
