require 'rack'
require 'rack/mock'
require 'rack/test'
require 'minitest/autorun'
require 'rack/domain_director'

class Minitest::Test
  include Rack::Test::Methods

  def app
    Rack::Lint.new(@app)
  end

  def mock_app(opts = {})
    @app = Rack::Builder.new do
      use Rack::DomainDirector,
          from: opts.fetch(:from, '.net'),
          to: opts.fetch(:to, '.com'),
          status: opts.fetch(:status, 301),
          before_redirect: opts.fetch(:before_redirect, ->(x){})

      run ->(env) { [200, {}, ['Hello']] }
    end
  end

  def assert_status(status)
    assert_equal status, last_response.status
  end

  def assert_location(location)
    assert_equal location, last_response.location
  end
end

class TestDomainDirector < Minitest::Test
  def setup
    mock_app
  end

  def test_that_it_redirects_net
    get 'http://example.net/123/abc'
    assert_location 'http://example.com/123/abc'
    assert_status 301
  end

  def test_that_it_wont_redirect_com
    get 'http://example.com/123/abc'
    assert_equal 'Hello', last_response.body
    assert_status 200
  end

  def test_that_it_conserves_scheme
    get 'https://example.net/123/abc'
    assert_location 'https://example.com/123/abc'
  end

  def test_that_it_conserves_non_standard_ports
    get 'http://example.net:9000/123/abc'
    assert_location 'http://example.com:9000/123/abc'
  end

  def test_that_it_conserves_query_strings
    get 'https://example.net/123/abc?a=b&c=d'
    assert_location 'https://example.com/123/abc?a=b&c=d'
  end
end

class TestDomainDirector_BeforeRedirectOption < Minitest::Test
  def setup
    @host = nil
    mock_app before_redirect: ->(req) { @host = req.host }
  end

  def test_before_redirect
    get 'http://example.net/123/abc'
    assert_equal 'example.net', @host
  end
end

class TestDomainDirector_StatusOption < Minitest::Test
  def setup
    mock_app status: 302
  end

  def test_that_it_modifies_status
    get 'http://example.net/123/abc'
    assert_status 302
  end
end

class TestDomainDirector_FromOptionAsArray < Minitest::Test
  def setup
    mock_app from: ['.net', '.org']
  end

  def test_that_it_redirects_net
    get 'http://example.net/123/abc'
    assert_location 'http://example.com/123/abc'
  end

  def test_that_it_redirects_org
    get 'http://example.org/123/abc'
    assert_location 'http://example.com/123/abc'
  end
end
