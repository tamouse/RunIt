# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'RunIt'

Gem::Specification.new do |spec|
  spec.name          = "RunIt"
  spec.version       = RunIt::VERSION
  spec.authors       = ["Tamara Temple"]
  spec.email         = ["tamouse@gmail.com"]
  spec.description   = "A simple class to wrap Open3#popen3"
  spec.summary       = "A simple class to wrap Open3#popen3"
  spec.homepage      = "https://github.com/tamouse/RunIt"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency('rdoc')
end
