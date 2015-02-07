# Rack::DomainDirector

Rack middleware for redirecting one domain to another.

Usage:

```ruby
use Rack::DomainDirector,
    from: 'example.net', # required
    to: 'example.com',   # required
    status: 302,  # optional, default: 301
    before_redirect: ->(req) {
                  # optional, default: no-op
    }
```

Or just TLD's only:

```ruby
use Rack::DomainDirector,
    from: '.net',
    to: '.com'
```
