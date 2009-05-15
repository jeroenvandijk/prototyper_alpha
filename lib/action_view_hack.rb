# The following code changes some of the rails internals so that it is possible to render dynamic templates (rails version 2.3.2)
module ActionView
  class PathSet

    def find_template_with_dynamic_template(original_template_path, format = nil, html_fallback = true)
      begin
        find_template_without_dynamic_template(original_template_path, format, html_fallback)
      rescue ActionView::MissingTemplate => exception
        dynamic_template_path = Prototyper::Base.template_path_for(original_template_path)
        return Template.new(dynamic_template_path , dynamic_template_path =~ /\A\// ? "" : ".").with_template_missing if dynamic_template_path 
        
        raise exception
      end
    end
    alias_method_chain :find_template, :dynamic_template
  
  end
  
  class Template

    def with_template_missing
      @template_missing = true
      self
    end

    def source_with_dynamic_template
      if @template_missing
        Prototyper::Base.template_for(template_path)
      else
        source_without_dynamic_template
      end
    end
    alias_method_chain :source, :dynamic_template
 
  end
end