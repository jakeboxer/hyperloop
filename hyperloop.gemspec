# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hyperloop/version"

Gem::Specification.new do |spec|
  spec.name          = "hyperloop"
  spec.version       = Hyperloop::VERSION
  spec.authors       = ["Jake Boxer"]
  spec.email         = ["jake@github.com"]
  spec.description   = %q{Hyperloop lets you make simple websites with a technology stack familiar to Rails programmers.}
  spec.summary       = %q{Make simple websites with Rails conventions and conveniences.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "coffee-script", "~> 2.2.0"
  spec.add_dependency "rack", "~> 1.5"
  spec.add_dependency "sass", "~> 3.2.12"
  spec.add_dependency "sprockets", "~> 2.10.0"
  spec.add_dependency "tilt", "~> 1.4.1"
  spec.add_dependency "yui-compressor", "~> 0.12.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "nokogiri", "~> 1.6.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
end
