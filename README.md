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

    index.html        #=> base layout file
    config.ru         #=> Rack file to allow for use with pow or any other rack app
    posts/text.html   #=> html for text post
    posts/….html      #=> html for each post type
    partials/….html   #=> html for each partial
    tumblr-themer.yml #=> config file

The utility can inject all the post types into the custom tag `{PostsCode}`
so that you can keep your theme more organized.

#### Partials

You can also generically use partials with the custom tag `{partial:PartialName}` will insert the html from the file `partials/partial_name.html`.

### Customization

The `tumblr-themer.yml` file contains configuration information.

The first thing you need is an api key, found at [tumblr's developer site](http://www.tumblr.com/oauth/apps). It's called the OAuth Consumer Key.

The second key can be the blog. It's your tumblr base name to get the posts from.

Optionally you can provide an array of posts to render.

### Server

You can run a server by the command

    $ tumblr-themer server

This starts a web server on localhost:4567.

You can use the [Pow](http://pow.cx) utility to run the server as well. In fact this method is the recommended way to use this utility.

### Loading

To take the html and put it into your tumblr account you can run

    $ tumblr-themer copy

and it will place the entire theme in your clipboard.

Alternately you can have it print out the whole theme with:

    $ tumblr-themer stdout

## Todo

So many things, starting with:

* Distinguishig between permalink/listing pages
* Testing
* More tag support for various post types
* Too much to list, please help out with what you want/can

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
