require 'action_view_hack'
require 'i18n_hack'
require 'prototyper/base'

Prototyper::Base.init

config.to_prepare do
  ApplicationController.helper(PrototypesHelper)
  
  # Also run things only when everything has been loaded
  if config.cache_classes
    Prototyper::Base.define_classes
  else
    require 'const_missing_hack'
    require 'dispatch_callback'
  end
end



