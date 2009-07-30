class PrototypeGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      
      path = File.join("app/prototypes")
      templates_path = File.join(path, "templates")
      default_templates_path = File.join(templates_path, "default") # unless exist or different templates directory is given
      view_default_templates_path = File.join(default_templates_path, "views")

      m.directory( default_templates_path )
      
      m.template("prototype.yml.rb", File.join(path, "#{singular_name}.yml"))
      m.file("seed.rb", File.join(path, "seed.rb"))
      m.file("helpers.rb", File.join(path, "helpers.rb"))

      %w(controller.rb model.rb).each do |file|
        m.file(file, File.join(templates_path, file) )
      end
      
      m.directory( view_default_templates_path )
      %w(_form _form_fields _list edit index new show).each do |file|
        m.file(File.join("views", "#{file}.html.haml"), File.join(view_default_templates_path, "#{file}.html.haml") )
      end        
      
    end
  end
  
end