lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rack/domain_director/version'

Gem::Specification.new do |gem|
  gem.name          = 'rack-domain_director'
  gem.version       = Rack::DomainDirector::VERSION
  gem.license       = 'MIT'
  gem.authors       = ['Larry Fox']
  gem.email         = ['l@rryfox.us']
  gem.homepage      = 'https://github.com/larryfox/rack-domain_director'
  gem.description   = 'Rack middleware for redirecting one domain to another.'
  gem.summary       = 'Rack middleware to redirect domains'

  gem.required_ruby_version = '>= 2.0' # most definitely less

  gem.files         += Dir.glob('lib/**/*.rb')
  gem.test_files    = Dir.glob('test/**/*')
  gem.require_paths = ['lib']
  gem.add_dependency 'rack'
end
