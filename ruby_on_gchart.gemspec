# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'GoogleChart/version'

Gem::Specification.new do |gem|
  gem.name          = "ruby_on_gchart"
  gem.version       = GoogleChart::VERSION
  gem.authors       = ["Herman verschooten", "Damien Mathieu"]
  gem.email         = ["Herman@verschooten.net"]
  gem.description   = %q{Generate Google Chart within Ruby/Rails}
  gem.summary       = %q{Generate Google Chart within Ruby/Rails}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
