[![Gem Version](https://badge.fury.io/rb/cache_rocket.svg)][gem]
[![Build Status](https://travis-ci.org/neighborland/cache_rocket.svg?branch=master)][build]
[![Coverage Status](http://img.shields.io/coveralls/neighborland/cache_rocket.svg)][coverage]
[![Code Climate](http://img.shields.io/codeclimate/github/neighborland/cache_rocket.svg)][climate]

[gem]: http://rubygems.org/gems/cache_rocket
[build]: https://travis-ci.org/neighborland/cache_rocket
[coverage]: https://coveralls.io/r/neighborland/cache_rocket
[climate]: https://codeclimate.com/github/neighborland/cache_rocket

## Rails rendering extension for server-side html caching

CacheRocket improves server-side fragment caching efficiency in Rails.
CacheRocket allows caching more generic html fragments and allows the contents of the cached fragments
to be replaced with dynamic content.

## Install

Add the gem to your Gemfile:

```ruby
gem 'cache_rocket'
```

Include the CacheRocket module so your views can use the `cache_replace` and `render_cached` methods.
Most likely you would put this in your `ApplicationHelper`:

```ruby
include CacheRocket
```

## Use

CacheRocket allows you to cache a fragment of html and replace inner html.
You inject dynamic content into a static, cached outer partial.

### `cache_replace`

The simplest usage is inline with the `cache_replace` method. It works
like Rails' `cache` method, plus it replaces content that you do not want
to cache because it is impractical or inefficient.

For example:

#### Before

```haml
.htmls
  = Time.now
```

#### After

```haml
- cache_replace("the-time", replace: { time: Time.now }) do
  .htmls
    = cache_replace_key :time
```

Now the fragment is cached once with a placeholder, and the time is always replaced when rendered.

Obviously, the above example is contrived and would not result in any
performance benefit. When the block of html you are rendering is large,
caching can help.

### `render_cached`

`render_cached` has options to deal with partials and collections.
Use it as a replacement for Rails' `render`, with `replace` options.
For example:

#### Before

##### file.html.haml:
```haml
= render 'outer'
```

##### _outer.html.haml:
```haml
.lots
  .of
    .htmls
      = Time.now
```

#### After

 Replace `render`
with `render_cached` in `file`, specify the content to replace, and cache `outer`:

##### file.html.haml:
```haml
= render_cached 'outer', replace: { inner: Time.now }
```

##### _outer.html.haml:
```haml
- cache 'outer' do
  .lots
    .of
      .htmls
        = cache_replace_key :inner
```

Here is the same example with an inner partial:

#### Before

##### file.html.haml:
```haml
= render 'outer'
```

##### _outer.html.haml:
```haml
.lots
  .of
    .htmls
      = render 'inner'
```

##### _inner.html.haml:
```haml
= Time.now
```

#### After

Replace `render` with `render_cached` in `file`,
specify the partial to replace in `outer`, and cache `outer`:

##### file.html.haml:
```haml
= render_cached 'outer', replace: 'inner'
```

##### _outer.html.haml:
```haml
- cache 'outer' do
  .lots
    .of
      .htmls
        = cache_replace_key :inner
```

##### _inner.html.haml:
``` haml
= Time.now
```

### Options

`render_cached` supports several styles of arguments:

#### Single partial to replace

```ruby
render_cached 'outer', replace: 'inner'
```

#### Array of partials to replace

```ruby
render_cached 'outer', replace: ['inner', 'footer']
```

#### Hash of keys to replace with values

```ruby
render_cached 'outer', replace: { key_name: a_method(object) }
```

#### Block containing a hash of keys to replace with values

```ruby
render_cached 'outer' do
  { key_name: a_method(object) }
end
```

#### Render a collection with hash of keys, using a lambda for each collection item

```ruby
render_cached 'outer', collection: objects,
  replace: { key_name: -> (object) { a_method(object) } }
```

#### Render a collection with block syntax

```ruby
render_cached 'outer', collection: objects do
  { key_name: -> (object) { a_method(object) } }
end
```

#### Render a collection with block syntax with multiple keys

```ruby
render_cached 'outer', collection: objects do
  {
    key_1: -> (object) { a_method(object) },
    key_2: -> (item) { item.name },
  }
end
```

## YMMV

`cache_rocket` is not magic. It should not be used in all situations.
Benchmark your page rendering times before and after to see if it helps.

## Benefits

#### More server-side caching

See the example above.

#### More efficient memory usage

Typically, one would key the `users/bio` partial on the `user` object like so:

##### users/bio.html.haml:

```haml
- cache [user, 'bio'] do
  .lots-of-htmls
    = user.bio
```

With 1000 users, there are 1000 cached items. This can use a lot of memory.
Instead we can cache the `users/bio` partial once and replace the content we need using
`cache_replace`. With 1000 users, we use 1/1000th the memory.

##### users/bio.html.haml:
```haml
- cache_replace('users/bio', replace: { bio: user.bio }) do
  .lots-of-htmls
    = cache_replace_key :bio
```

#### Simpler cache keys

If you have a cache key containing multiple models, it will generally be very inefficient:

```haml
- cache(user, other_user) do
  = render 'common_interests'
```

If the cached content is rarely retrieved, `render_cached` can help:

```haml
- cache('common_interests') do
  .htmls
    = cache_replace_key :something
```

```haml
= render_cached 'common_interests', replace: { something: 'common_interests/inner' }
```

#### Faster first page loads

By caching common html, you ensure that you will render cached content the first time a model-dependent
fragment is rendered. See the `Use far less memory` section above for an example.

### References

* Slides from Boulder Ruby presentation: http://www.slideshare.net/teeparham/rails-html-fragment-caching-with-cache-rocket
* Rails cache benchmark test app: https://github.com/teeparham/cache_benchmark
