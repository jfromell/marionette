$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'marionette/version'

Gem::Specification.new do |s|
  s.name = 'Marionette'
  s.version = Marionette::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.files = `git ls-files -- lib/*`.split('\n')
  s.require_path = 'lib'
end