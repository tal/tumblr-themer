# Tumblr Themer

A utility for making tumblr themes easier. Generates a framework for the theme and runs a server to allow you to see your theme with real data while you test.

## Installation

Install with

    $ gem install tumblr-themer

## Usage

### Generation

Once installed you can generate a base theme in a new folder with

    $ tumblr-themer new theme_name

or have it place the files in the current directory with:

    $ tumblr-themer new .

The folder structure generated is as such:

    index.html      #=> base layout file
    config.ru       #=> Rack file to allow for use with pow or any other rack app
    posts/text.html #=> html for text post
    posts/….html    #=> html for each post type
    
The utility can inject all the post types into the custom tag `{PostsCode}`
so that you can keep your theme more organized. I'm looking to add more custom partial support in the future.

### Server

You can run a server by the command

    $ tumblr-themer server

This starts a web server on localhost:4567.

### Loading

To take the html and put it into your tumblr account you can run

    $ tumblr-themer copy

and it will place the entire theme in your clipboard.

Alternately you can have it print out the whole theme with:

    $ tumblr-themer stdout
    
## Todo

So many things, starting with:

* Distinguishig between permalink/listing pages
* More tag support for various post types
* Too much to list, please help out with what you want/can

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
