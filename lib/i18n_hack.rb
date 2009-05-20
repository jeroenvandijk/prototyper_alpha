module ActionView
  class Base
    
    # Adds a few options to translate. If key starts with .key it will default to default and it will add model and models name as options
    def translate_with_context(key, options = {})
      key_as_string = key.to_s.dup
      if key_as_string.first == "."
        new_key = template.path_without_format_and_extension.gsub(%r{/_?}, ".") + key_as_string
        resource = new_key.split('.').first.singularize

        with_options :scope => [:activerecord, :models] do |with|
          options[:model] ||= with.translate(resource, :default => resource.humanize, :count => 1)
          options[:models] ||= with.translate(resource, :default => resource.pluralize.humanize, :count => 2)
        end
        
        default_key = new_key.gsub(resource.pluralize, 'default')
        default_key.gsub!(".#{resource}.", ".partial.") # in case of partial

        options[:default] ||= translate(default_key , options.dup)

        translate_without_context(new_key, options)
      else
        translate_without_context(key, options)
      end
    end
    alias_method_chain :translate, :context
    
    def t_with_context(*args)
      translate_with_context(*args)
    end
    alias_method_chain :t, :context

  end
end
