# Rack::DomainDirector

Rack middleware for redirecting one domain to another.

[![Build Status](https://travis-ci.org/larryfox/rack-domain_director.svg?branch=master)](https://travis-ci.org/larryfox/rack-domain_director)
[![Code Climate](https://codeclimate.com/github/larryfox/rack-domain_director/badges/gpa.svg)](https://codeclimate.com/github/larryfox/rack-domain_director)

Usage:

```ruby
use Rack::DomainDirector,
    from: 'example.net', # required
    to: 'example.com',   # required
    status: 302,  # optional, default: 301
    before_redirect: ->(request) {
                  # optional, default: no-op
    }
```

Or just TLD's only:

```ruby
use Rack::DomainDirector,
    from: '.net',
    to: '.com'
```

With an Array:

```ruby
use Rack::DomainDirector,
    from: ['.net', '.org'],
    to: '.com'
```
