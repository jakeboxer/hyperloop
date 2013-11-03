# Hyperloop [![Build Status](https://travis-ci.org/jakeboxer/hyperloop.png?branch=master)](https://travis-ci.org/jakeboxer/hyperloop)

Hyperloop is a framework that lets you make static websites with a technology stack familiar to Rails programmers.

Before you keep reading, let's get one thing out of the way:

### If you think your website might need a database, do not use Hyperloop.

I came up with the idea for Hyperloop after hearing one too many experienced web developers say "I don't even know how
to set up a regular website anymore."

With Hyperloop, you can create a new site just like you would with Rails. You can write ERB and Sass and CoffeeScript
and all that other good stuff. You can use layouts and partials and deploy to Heroku.

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

### Layout

Your layout is in `app/views/layouts/application.html.erb`.

### Views

Your site root is in `app/views/index.html.erb`.

If you create `app/views/hello.html.erb`, you'll be able to get to it by going to
[http://localhost:3000/hello/](http://localhost:3000/hello/).

### Subdirectories

You can nest views in subdirectories. If you create the following files, the following URLs will work:

- `app/views/people/ted_nyman.html.erb` will make [http://localhost:3000/people/ted_nyman/](http://localhost:3000/people/ted_nyman/) work.
- `app/views/people/index.html.erb` will make [http://localhost:3000/people/](http://localhost:3000/people/) work.
- `app/views/projects/2013/yeezus.html.erb` will make [http://localhost:3000/projects/2013/yeezus/](http://localhost:3000/projects/2013/yeezus/) work.

### Partials

If you create `app/views/_some_section.html.erb`, you'll be able to load it as a partial almost like you would in Rails:

``` ruby
<%= render "some_section" %>
```

Note: In Rails, it's `<%= render :partial => "some_section" %>`, since there are other things you could want to render
besides a partial. In Hyperloop, there aren't, so the options hash isn't necessary.

### CSS, SCSS, Sass, JavaScript, and CoffeeScript

If you create some files like:

```
app/assets/stylesheets/bootstrap.css
app/assets/stylesheets/stylez1.css
app/assets/stylesheets/stylez2.scss
app/assets/javascripts/jquery.js
app/assets/javascripts/scriptz1.js
app/assets/javascripts/scriptz2.coffee
```

They'll be included in all your views, so long as you have these two tags:

``` html
<!-- I suggest putting this in between <head> and </head> -->
<link href="/assets/stylesheets/app.css" media="all" rel="stylesheet" type="text/css">

<!-- I suggest putting this at the end of the document body (as in, right before </body>) -->
<script src="/assets/javascripts/app.js" type="text/javascript"></script>
```

somewhere in your layout. All your CSS and JS assets belong in these folders, including vendored ones like jQuery and Bootstrap.

### Images

If you create `app/assets/images/photo.jpg`, you'll be able to show it in a view with `<img src="/assets/images/photo.jpg">`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
