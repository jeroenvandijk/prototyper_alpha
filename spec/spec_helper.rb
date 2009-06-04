require 'rubygems'
require 'actionmailer'
require 'spec'
require 'active_record'
require File.expand_path(File.dirname(__FILE__) + '/../lib/const_missing.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/i18n_hack.rb')
require File.expand_path(File.dirname(__FILE__) + '/../lib/prototyper/base.rb')

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + '/../' )

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

# Dummies
class ApplicationController; end