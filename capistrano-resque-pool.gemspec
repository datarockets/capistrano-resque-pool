# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require 'capistrano-resque-pool/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-resque-pool"
  spec.version       = CapistranoResquePool::VERSION
  spec.authors       = ["Maxim Abramchuk", "Dmitry Zhlobo"]
  spec.email         = ["maximabramchuck@gmail.com"]
  spec.summary       = %q{Capistrano integration for Resque pool}
  spec.description   = %q{Capistrano integration for Resque pool}
  spec.homepage      = "https://github.com/datarockets/capistrano-resque-pool"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  %w(bundler rake).each do |dependency|
    spec.add_development_dependency dependency
  end

  %w(capistrano resque-pool).each do |dependency|
    spec.add_dependency dependency
  end
end
