# coding: utf-8
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'marionette/version'

Gem::Specification.new do |s|
  s.name = 'marionette'
  s.version = Marionette::VERSION
  s.authors = ['Jonas Fromell']
  s.files = `git ls-files`.split($/)
  s.require_path = ['lib']
end