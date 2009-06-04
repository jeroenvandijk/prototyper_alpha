require 'action_view_hack'
require 'i18n_hack'
require 'prototyper/base'
require 'dispatch_callback'
require 'const_missing'

Prototyper::Base.init

config.to_prepare do
  ApplicationController.helper(PrototypesHelper)
end
