require File.join(File.dirname(__FILE__), '../../lib/prototyper/generator')

class PrototypeExportGenerator < Rails::Generator::NamedBase
  attr_reader :prototype
  delegate *Prototyper::Prototype::ACCESSORS << { :to => :prototype }

  def initialize(runtime_args, runtime_options = {})
    prototype_name = runtime_args.first
    @prototype = Prototyper::Base.find_prototype_for(prototype_name)
    raise "Couldn't find prototype '#{prototype_name}'" unless @prototype
    
    # Include template helpers
    Prototyper::Base.eval_template_helpers(binding)
    
    super
  end
  
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions( controller_class_path, "#{class_name}Controller")
      m.class_collisions( controller_class_path, "#{class_name}Helper")
      # m.class_collisions( class_path, class_name)                                 
  
      # Controller, helper, views, and test directories.
      m.directory(File.join('app/controllers', controller_class_path) )
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, plural_name) )

      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/spec/models', class_path))
      
      m.template(File.join(relative_root_path, template_path, "controller.rb"), File.join('app', 'controllers', "#{table_name}_controller.rb"))

      m.template(File.join(relative_root_path, template_path, "model.rb"), File.join('app', 'models', "#{file_name}.rb"))
      m.template( File.join(relative_root_path, template_path, 'model_spec.rb'),       File.join('spec/models', "#{file_name}_spec.rb") )

      # Generate views
      view_templates.each do |template|
        target_template = template.split('.').first == "_object" ? template.gsub("_object", "_#{singular_name}") : template.dup
        
        m.template(File.join(relative_root_path, view_template_path, template), File.join('app', 'views', controller_class_path, plural_name, target_template) )
      end
    
      # Reuse some templates
      m.template("scaffold:helper.rb", File.join('app/helpers', "#{controller_file_name}_helper.rb") )
    
      # Reuse Cucumbers feature template
      m.dependency "feature", [singular_name] + (associations + attributes).map{|x| "#{x.name}:#{x.type}"}
    end
  end
    
  def relative_root_path
    "../" * 6
  end
  
  def view_templates
    Dir[File.join(view_template_path, "*")].map {|x| File.basename(x) }
  end
  
  def view_template_path
    File.join(template_path, "views")
  end
  
  def template_path
    File.join("app", "prototypes", "templates", "default")
  end

end