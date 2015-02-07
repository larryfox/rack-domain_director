require 'rack'
require 'rack/domain_director/request'

class Rack::DomainDirector
  def initialize(app, opts = {})
    @app             = app
    @to              = opts.fetch(:to)
    @from            = opts.fetch(:from)
    @status          = opts.fetch(:status, 301)
    @before_redirect = opts.fetch(:before_redirect, ->(req) {})
  end

  def call(env)
    req = Rack::DomainDirector::Request.new(env)

    if redirectable?(req)
      redirect(req)
    else
      @app.call(env)
    end
  end

  private

  def redirect(req)
    @before_redirect.call(req)
    req.host = req.host.sub(%r{#{ Regexp.escape(@from) }$}, @to)
    [@status, {'Location' => req.url}, []]
  end

  def redirectable?(req)
    req.host.end_with?(@from)
  end
end
