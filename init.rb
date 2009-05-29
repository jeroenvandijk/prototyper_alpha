require 'action_view_hack'
require 'i18n_hack'
require 'prototyper/base'
require 'dispatch_callback'
require 'const_missing'

Prototyper::Base.init

config.to_prepare do
  ApplicationController.helper(PrototypesHelper)
end

config.to_prepare do
  # The controller should be defined when the ApplicationController (the superclass has been completely loaded including helpers)
  # Prototyper::Base.init_models
  # Prototyper::Base.init_controllers
end


# require 'dispatcher'
# module ActionController
#   class Dispatcher
#     def start_timer
#       @start_time = Time.now
#     end
#     
#     def end_timer
#       raise "test"
#     end
#     
#     before_dispatch :start_timer
#     after_dispatch :end_timer
#   end
# end
