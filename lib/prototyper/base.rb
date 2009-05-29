require 'erb'

%w(missing_templates prototype reader renderer).each do |file|
  require File.expand_path(File.join(File.dirname(__FILE__) + "/#{file}"))
end

module Prototyper
  class Base
    include MissingTemplates
    include Renderer
    extend Reader
    
    def self.rendered_template_for(resource, template)
      locals = find_prototype_for(resource).to_locals
      render_template(template, locals)
    end
    
    def self.prototypes
      # TODO load all files in 'app/prototypes'
      @@prototypes ||= read File.join(RAILS_ROOT, "app/prototypes", "linktool.yml")
    end
    
    def self.cleanup_prototypes
      prototypes.each do |prototype|
        Object.instance_eval{ remove_const(prototype.controller_name) }
        Object.instance_eval{ remove_const(prototype.class_name) }
      end
    end
    
    def self.init
      RAILS_DEFAULT_LOGGER.info "="*100
      RAILS_DEFAULT_LOGGER.info " Initializing prototype plugin"
      RAILS_DEFAULT_LOGGER.info "="*100
      prototypes #trigger to load everything
            
      # Run migrations before others so that tables are present before defining active records classes
      Migrator.reinstall if prototypes_definition_changed?
    end
    
    def self.init_models
      eval_for_each_prototype do |prototype|
        run_template(:model, prototype.to_locals)
      end
    end
    
    # Controllers need a special treatment since helpers are added on each request
    def self.init_controllers
      eval_for_each_prototype do |prototype|
        run_template(:controller,  prototype.to_locals)
      end
    end
    
    def self.eval_for_each_prototype
      prototypes.each do |prototype|
        begin
          yield(prototype)
        rescue StandardError => e
          raise "The following error for prototype '#{prototype.name}' has occured: #{e}"
        end
      end
    end

    # Deprecated
    # def self.load(model_definition)
    #   @@prototypes = model_definition
    # 
    #   
    #   prototypes.each_pair do |name, fields| 
    #     locals = {
    #       :singular_name => name,
    #       :plural_name => name.pluralize
    #     }
    # 
    #     run_template(:model, locals)
    #     run_template(:controller, locals)
    #   end
    #   
    #   Migrator.reinstall
    #   add_routes
    # end
    
    def self.unload(model_definition)
      Migrator.uninstall
    end
    
    def self.find_prototype_for(resource_name)
      prototypes.find { |p| p.name == resource_name.to_s.singularize }
    end
    
    def self.render_view_template(name, assigns)
      render_template_from("app/prototypes/templates/default/views/#{name}", assigns)
    end
    
    def self.render_template(name, assigns)
      render_template_from("app/prototypes/templates/default/#{name}", assigns)
    end
    
    def self.run_template(name, assigns)
      run_template_from("app/prototypes/templates/default/#{name}.rb", assigns)
    end


    
    private
      def self.prototype_names
        @names ||= prototypes.map(&:name)
      end
    
    
  end  
end