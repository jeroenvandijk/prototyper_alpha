module Prototyper
  module Renderer
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def render_template_from(path, assigns)
        begin
          code = render_file(path, :assigns => assigns)
        rescue StandardError => e
          raise "'#{e}' while rendering prototype template '#{path}'}"
        end
      end

      def run_template_from(path, assigns)
        code = render_template_from(path, assigns)
    
        begin
          eval(code, TOPLEVEL_BINDING)
        rescue StandardError => e
          raise "'#{e}' while running prototype template '#{path}'"
        end

      end
      
      # TODO move this to a configuration place?
      def eval_template_helpers(temporary_binding)
        unless @helper_code
          helper_path = "app/prototypes/helpers.rb"
          @helper_code = read_file (helper_path, :raise => true)
        end
        
        eval(@helper_code, temporary_binding)
      end

      # Copy from the rails generator, with a helpers extension
      def render_file(relative_path, template_options = {})
        # Evaluate any assignments in a temporary, throwaway binding.
        vars = template_options[:assigns] || {}
        b = template_options[:binding] || binding
        vars.each { |k,v| eval "#{k} = vars[:#{k}] || vars['#{k}']", b }
        eval_template_helpers(binding)

        source = read_file(relative_path)
        ERB.new(source, nil, '-').result(b)
      end
      
      # Reads a file given the relative path (to the RAILS_ROOT), returns an empty string when the file wasn't found
      def read_file(relative_path, options = {})
        source_path = File.join(RAILS_ROOT, relative_path)
        File.exists?(source_path) || options[:raise] ? File.open(source_path, 'r').read : ""
      end
      
    end
    
    
  end
end