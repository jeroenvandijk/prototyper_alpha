module ActionController
  class Dispatcher
    def cleanup_prototypes
      Prototyper::Base.cleanup_prototypes
    end
    
    after_dispatch :cleanup_prototypes
  end
end