require 'time'
require 'url'
require 'json'
require "yaml"
require 'cgi'

require "tumblr-themer/version"

module TumblrThemer
  def self.settings dirname='.'
    file = File.expand_path("#{dirname}/tumblr-theme.yml")

    unless File.exist?(file)
      raise ConfigFileError, "#{file} not found"
    end

    data = YAML.load_file(file)
    raise ConfigFileError, "no api_key found in config file" unless data['api_key']
    data
  end

  class ConfigFileError < StandardError; end
end

require 'tumblr-themer/api'
require 'tumblr-themer/tag_helper'
require 'tumblr-themer/html_snippet'
require 'tumblr-themer/tag'
require 'tumblr-themer/photoset_photo'
require 'tumblr-themer/chat_line'
require 'tumblr-themer/post'
require 'tumblr-themer/theme'
require 'tumblr-themer/post/audio'
require 'tumblr-themer/post/quote'
require 'tumblr-themer/post/text'
require 'tumblr-themer/post/photo'
require 'tumblr-themer/post/photoset'
require 'tumblr-themer/post/link'
require 'tumblr-themer/post/video'
require 'tumblr-themer/post/chat'
