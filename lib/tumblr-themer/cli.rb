require 'thor'
require 'tumblr-themer/server'

class TumblrThemer::CLI < Thor
  class_option :'theme-dir', :type => :string, default: '.', aliases: %w{-t}

  desc 'copy', 'copy the theme into the clipboard'
  def copy
    theme = TumblrThemer::Theme.new(options[:'theme-dir'])

    IO.popen('pbcopy', 'w') { |f| f << theme.body.to_s }
  end

  desc 'stdout', 'print theme to stdout'
  def stdout
    theme = TumblrThemer::Theme.new(options[:'theme-dir'])

    puts theme.body
  end

  desc 'server', 'run a server that allows you to play with your theme in the browser'
  def server
    TumblrThemer::Server.run!
  end
end
