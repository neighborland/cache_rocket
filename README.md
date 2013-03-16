# Rails rendering extension for more server-side html caching

## Why do I need this?

To squeeze the last drop out of server-side HTML caching in Rails. Use this after you have configured as
much in-memory caching as possible and it's still not enough.

## Install

Add this line to your Gemfile:

    gem 'cache_replace'

Add this line to a helper file, likely your ApplicationHelper:

    include CacheReplace

## Use

This gem allows you to easily cache a partial of static html and replace inner dynamic html. Here is an example
scenario where this is helpful:

You have some html that would be cached, except for some uncacheable code nested in the DOM. For example:

##### file.html.haml:
```
= render 'container'
```

##### _container.html.haml:
```
.lots
  .of
    .htmls
      = render 'dynamic'
```

##### _dynamic.html.haml:
```
= complicated_uncacheable_stuff
```

Sad times. You can't cache anything without resorting to madness. Oh snap! But you can:

##### file.html.haml:
```
= render_cached 'container', replace: 'dynamic'
```

##### _container.html.haml:
```
- cache "container" do
  .lots
    .of
      .htmls
        = cache_replace_key 'dynamic'
```

##### _dynamic.html.haml:
```
= complicated_uncacheable_stuff
```

In the above example, you could also remove the `_dynamic.html.haml` file and do this:

##### file.html.haml:
```
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
render_cached "container", replace: {special_link: special_link(object)}
```

#### Yield to a hash of keys to replace with values
```ruby
render_cached "container" do
  {special_link: special_link(object)}
end
```

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
