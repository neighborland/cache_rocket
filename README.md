[![Gem Version](https://badge.fury.io/rb/cache_rocket.png)][gem]
[![Build Status](https://api.travis-ci.org/teeparham/cache_rocket.png)][build]
[![Code Climate](https://codeclimate.com/github/teeparham/cache_rocket.png)][climate]

[gem]: http://badge.fury.io/rb/cache_rocket
[build]: https://travis-ci.org/teeparham/cache_rocket
[climate]: https://codeclimate.com/github/teeparham/cache_rocket

# Rails rendering extension for server-side html caching

## Why do I need this?

To improve fragment caching efficiency in Rails by only caching the things that change.
CacheRocket may be used in with other Rails caching strategies such as Russian Doll caching.

## Install

Add this line to your Gemfile:

```ruby
gem 'cache_rocket'
```

Add this line to a helper file, likely your ApplicationHelper:

```ruby
include CacheRocket
```

## Use

This gem allows you to easily cache a partial of static html and replace inner dynamic html. Here is an example
scenario:

You have some html that would be cached, except for some uncacheable code nested in the DOM. For example:

##### file.html.haml:
```haml
= render 'container'
```

##### _container.html.haml:
```haml
.lots
  .of
    .htmls
      = render 'dynamic'
```

##### _dynamic.html.haml:
```haml
= complicated_uncacheable_stuff
```

In the scenario above, you can't cache anything. With `cache_rocket`, you can:

##### file.html.haml:
```haml
= render_cached 'container', replace: 'dynamic'
```

##### _container.html.haml:
```haml
- cache "container" do
  .lots
    .of
      .htmls
        = cache_replace_key 'dynamic'
```

##### _dynamic.html.haml:
``` haml
= complicated_uncacheable_stuff
```

In the above example, you could also remove the `_dynamic.html.haml` file like so:

##### file.html.haml:
```haml
= render_cached 'container', replace: {dynamic: complicated_uncacheable_stuff}
```

## Options

`render_cached` provides 4 calling styles:

#### Single partial to replace

```ruby
render_cached "container", replace: "inner"
```

#### Array of partials to replace
```ruby
render_cached "container", replace: ["inner"]
```

#### Map of keys to replace with values
```ruby
render_cached "container", replace: {key_name: a_helper_method(object)}
```

#### Yield to a hash of keys to replace with values
```ruby
render_cached "container" do
  {key_name: a_helper_method(object)}
end
```

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
