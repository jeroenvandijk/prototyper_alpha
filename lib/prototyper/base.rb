require 'erb'

%w(missing_templates prototype reader renderer attribute association).each do |file|
  require File.expand_path(File.join(File.dirname(__FILE__) + "/#{file}"))
end

module Prototyper
  class Base
    include MissingTemplates
    include Renderer
    extend Reader
    
    # Keeps track of all defined_prototypes so they can be destroyed when necessary
    @@defined_prototypes = []
    
    def self.rendered_template_for(resource, template)
      locals = find_prototype_for(resource).to_locals
      render_template(template, locals)
    end
    
    def self.prototypes
      # TODO load all files in 'app/prototypes'
      
      
      
      @@prototypes ||= read File.join(RAILS_ROOT, "app/prototypes")
    end
    
    def self.previous_prototypes
      @@previous_prototypes ||= load_previous
    end
    
    def self.cleanup_prototypes
      # raise @@defined_prototypes.inspect
      @@defined_prototypes.each do |class_name|
        Object.instance_eval{ remove_const(class_name) if Object.const_defined?(class_name) }
      end
      
      @@defined_prototypes = []
    end
    
    def self.init
      prototypes #trigger to load everything

      ActionController::Routing::RouteSet::Mapper.send :include, Routes
            
      # Run migrations before others so that tables are present before defining active records classes
      Migrator.reinstall if prototypes_definition_changed?
    end
    
    def self.has_definition_for?(name)
      !!find_prototype_for(extract_prototype_name(name))
    end
    
    # Used when config.cache_classes is true
    def self.define_classes
      prototypes.each do |prototype|
        if ActiveRecord::Migration.table_exists?(prototype.plural_name) # to prevent error when migrating from zero
          define(:type => :model, :for => prototype)
          define(:type => :controller, :for => prototype)
        end
      end
      
    end
    
    def self.define(options = {})      
      prototype = options[:for] || find_prototype_for(extract_prototype_name(options[:class]))

      if prototype
        template = options[:type] || (options[:class].to_s.slice("Controller") ? :controller : :model)

        begin
          run_template(template, prototype.to_locals)
        rescue StandardError => e
          raise "The following error for #{template} prototype '#{prototype.name}' has occured: #{e}"
        end

        if options[:class]
          @@defined_prototypes << options[:class]
          options[:class].to_s.constantize
        end
      end
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

    def self.extract_prototype_name(name)
      class_name = name.to_s.dup
      class_name.gsub("Controller", '').singularize.underscore
    end
    
    
  end  
end