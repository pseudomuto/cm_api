# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cm_api/version"

Gem::Specification.new do |spec|
  spec.name          = "cm_api"
  spec.version       = CMAPI::VERSION
  spec.authors       = ["David Muto (pseudomuto)"]
  spec.email         = ["david.muto@gmail.com"]

  spec.summary       = "A Cloudera Manager API Client in Ruby"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/pseudomuto/cm_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
