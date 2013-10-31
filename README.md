# Hyperloop [![Build Status](https://travis-ci.org/jakeboxer/hyperloop.png?branch=master)](https://travis-ci.org/jakeboxer/hyperloop)

Hyperloop is a framework that lets you make static websites with a technology stack familiar to Rails programmers.

Before you keep reading, let's get one thing out of the way:

### If you think your website might need a database, do not use Hyperloop.

I came up with the idea for Hyperloop after hearing one too many competent web developers say "I don't even know how to
set up a regular website anymore."

With Hyperloop, you can create a new site just like you would with Rails. You can write ERB and Sass and CoffeeScript
and all that other good shit. You can use layouts and partials and deploy to Heroku.

Basically, you can do all the stuff you're used to with Rails. On top of that, you don't have to type any of the magic
incantations that just aren't necessary in a static site. You don't have to set up routes. You don't have to make
controllers with a method for every view. You don't have to think about environments or tests or schemas or helpers or
any of the other boilerplate directories/files that would clutter up a static site being shoehorned into a Rails app.

## Getting Started

1. Install Hyperloop and Thin at the command prompt if you haven't yet:

        gem install hyperloop
        gem install thin

2. At the command prompt, create a new Hyperloop site:

        hyperloop new mysite

   where "mysite" is the site name.

3. Change directory to `mysite` and start the web server:

        cd mysite
        thin start

4. Go to [http://localhost:3000/](http://localhost:3000/) and you'll see your brand new website!

## Structure

Your layout is in `app/views/layouts/application.html.erb`.

Your site root is in `app/views/index.html.erb`.

If you create `app/views/hello.html.erb`, you'll be able to get to it by going to
[http://localhost:3000/hello](http://localhost:3000/hello).

If you create some files like:

```
app/assets/stylesheets/stylez1.css
app/assets/stylesheets/stylez2.scss
app/assets/javascripts/scriptz1.js
app/assets/javascripts/scriptz2.coffee
```

They'll be included in all your views, so long as you have these two tags:

``` html
<!-- I suggest putting this in between <head> and </head> -->
<link href="/assets/app.css" media="all" rel="stylesheet" type="text/css">

<!-- Minds more intelligent than mine suggest putting this at the end of the document body -->
<!-- As in, right before </body> -->
<script src="/assets/app.js" type="text/javascript"></script>
```

somewhere in your layout.

If you create `app/assets/images/photo.jpg`, you'll be able to show it in a view with `<img src="/assets/photo.jpg">`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
