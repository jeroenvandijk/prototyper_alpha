module Prototyper
  module MissingTemplates
    def self.included(base)
      base.extend ClassMethods
    end
  
    module ClassMethods
      
      # Returns the original path but with an extension according to the dynamic template that exists
      # Returns nil if no suitable template exist
      def template_path_for(template_path)
        resource, found_template = resource_and_found_template(template_path)
                
        if found_template && find_prototype_for(resource)
          File.join(resource, found_template)
        else
          nil
        end
      end
      
      def template_for(template_path)
        resource, found_template = resource_and_found_template template_path, :real_template => true
        render_view_template found_template, find_prototype_for(resource).to_locals
      end

      private

      # Extracts resource and finds template from template path. Returns nil when not nil for found template if nothing was found.
      def resource_and_found_template(template_path, options = {})
        resource, template = template_path.split('/')

        raw_template_path = find_template_path(resource, template, options)
        found_template = raw_template_path.split('/').last if raw_template_path

        [resource, found_template]
      end

      def find_template_path(resource, template_name, options = {})
        tmp_template_name = template_name.to_s.dup
        
        # Handle the special case of a partial that has the name of the resource
        singular_partial_name = "_#{resource.singularize}"
        tmp_template_name.gsub!(singular_partial_name, '_object') if tmp_template_name.include?(singular_partial_name)
        
        path = File.join("app", "prototypes", "templates", "default", "views")
        template_path = Dir.glob("#{path}/#{tmp_template_name}*").first
        
        # In case of rendering we want to return the real path, but otherwise Rails should be fooled.
        if options[:real_template]
          template_path
        else
          template_path && template_path.gsub('_object', singular_partial_name)
        end
      end

    end
  end
end