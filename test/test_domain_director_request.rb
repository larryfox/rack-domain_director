require 'minitest/autorun'
require 'rack/mock'
require 'rack/domain_director/request'

class TestDomainDirectorRequest < Minitest::Test
  def setup
    @req = Rack::DomainDirector::Request.new \
      Rack::MockRequest.env_for('http://example.com:8080/')
  end

  def test_it_conserves_host
    assert_equal 'example.com', @req.host
  end

  def test_it_modifies_host
    @req.host = 'test.example.com'
    assert_equal 'test.example.com', @req.host
  end
end
