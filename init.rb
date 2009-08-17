require 'action_view_hack'
require 'i18n_hack'
require 'prototyper/base'

Prototyper::Base.init

# The initializers should be prepared for helpers and dynamic generated classes (models, controllers)
# Depending on the setting config.cache_classes class should be predefined or classes should be defined through const_missing
config.to_prepare do
  ApplicationController.helper(PrototypesHelper)
  
  # Also run things only when everything has been loaded
  if config.cache_classes
    Rails.logger.info "---------- pre-defining prototypes ----------"
    Prototyper::Base.define_classes
  else
    Rails.logger.info "---------- removing prototypes, and waiting for missing ones ----------"
    require 'const_missing_hack'
    require 'dispatch_callback'
  end
end


