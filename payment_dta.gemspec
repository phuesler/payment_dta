# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payment_dta/version'

Gem::Specification.new do |spec|
  spec.name = "payment_dta"
  spec.version       = DTA::VERSION
  spec.require_paths = ["lib"]
  spec.authors = ["Patrick Huesler"]
  spec.description = "Generate Swiss DTA payment files to extract payments from your existing application"
  spec.summary = "Ruby library to generate Swiss DTA payment files"
  spec.email = "patrick.huesler@gmail.com"
  spec.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  spec.license = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.homepage = "http://github.com/phuesler/payment_dta"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rubigen"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rake"
end

