# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'favor/api/client/version'

Gem::Specification.new do |spec|
  spec.name          = "favor-api-client"
  spec.version       = Favor::Api::Client::VERSION
  spec.authors       = ["Takayuki Hasegawa"]
  spec.email         = ["takayuki.hasegawa0311@gmail.com"]

  spec.summary       = %q{FAVOR API Client for Ruby.}
  spec.description   = %q{FAVOR API Client for Ruby. see: http://favor.life/ }
  spec.homepage      = "https://github.com/hase1031/favor-api-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.3"
end
