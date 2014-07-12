# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'database_url/version'

Gem::Specification.new do |spec|
  spec.name          = "database_url"
  spec.version       = DatabaseUrl::VERSION
  spec.authors       = ["Seamus Abshere"]
  spec.email         = ["seamus@abshere.net"]
  spec.description   = %q{Convert back and forth between Heroku-style ENV['DATABASE_URL'] and Sequel/ActiveRecord-style config hashes.}
  spec.summary       = %q{Convert back and forth between Heroku-style ENV['DATABASE_URL'] and Sequel/ActiveRecord-style config hashes.}
  spec.homepage      = "https://github.com/seamusabshere/database_url"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
