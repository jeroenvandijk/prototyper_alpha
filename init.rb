require 'action_view_hack'
require 'i18n_hack'
require 'prototyper/base'
Prototyper::Base.init

config.to_prepare do
  ApplicationController.helper(PrototypeHelper)
end