require 'thor'
require 'tumblr-themer/server'

module TumblrThemer
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__),'..','..','theme_template'))
    end

    class_option :'theme-dir', :type => :string, :default => '.', :aliases => %w{-t}

    desc 'new', 'make a new theme in a folder of the name'
    def new name='.'
      @name = name

      files = Dir[File.join(self.class.source_root,'**/*.tt')].collect do |f|
        f.sub(self.class.source_root+'/','')
      end

      files.each do |source|
        if name == '.' || name == File.basename(Dir.pwd)
          dest = ""
        else
          dest = "#{name}/"
        end
        dest << source.sub(/\.tt$/, '')

        template source, dest
      end
    end

    desc 'copy', 'copy the theme into the clipboard'
    def copy
      theme = TumblrThemer::Theme.new(options[:'theme-dir'],:prod)

      IO.popen('pbcopy', 'w') { |f| f << theme.body.to_s }
    end

    desc 'stdout', 'print theme to stdout'
    def stdout
      theme = TumblrThemer::Theme.new(options[:'theme-dir'],:prod)

      puts theme.body
    end

    desc 'server', 'run a server that allows you to play with your theme in the browser'
    def server
      TumblrThemer::Server.run!
    end
  end

  class TemplateBuilder < Thor
  end
end
