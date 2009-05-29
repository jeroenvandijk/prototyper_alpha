module ActionController
  class Dispatcher
    def cleanup_prototypes
      Prototyper::Base.cleanup_prototypes
      RAILS_DEFAULT_LOGGER.info "="*100
      RAILS_DEFAULT_LOGGER.info " Cleaning up prototypes"
      RAILS_DEFAULT_LOGGER.info "="*100
    end
    
    def prepare_prototypes
      RAILS_DEFAULT_LOGGER.info "="*100
      RAILS_DEFAULT_LOGGER.info " Preparing prototypes"
      RAILS_DEFAULT_LOGGER.info "="*100
      # Prototyper::Base.init_models
    end
    
    before_dispatch :prepare_prototypes
    # 
    after_dispatch :cleanup_prototypes
  end
end