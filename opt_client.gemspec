# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opt_client/version'

Gem::Specification.new do |spec|
  spec.name          = "opt_client"
  spec.version       = OptClient::VERSION
  spec.authors       = ["stopanko"]
  spec.email         = ["stepander007@gmail.com"]

  spec.summary       = 'test api gem for test_api repo'
  spec.description   = 'test api gem for test_api repo'
  spec.homepage      = "https://github.com/stopanko/opt_client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'https://github.com/stopanko/opt_client'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "data_mapper"
  spec.add_runtime_dependency "json"
end
