require 'rubygems'
require 'actionmailer'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + '/../lib/i18n_hack.rb')
 

Spec::Runner.configure do |config|
  config.mock_with :mocha
end