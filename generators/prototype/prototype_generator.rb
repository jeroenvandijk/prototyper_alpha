class PrototypeGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      
      path = File.join("app/prototypes")
      templates_path = File.join(path, "templates")
      default_templates_path = File.join(templates_path, "default") # unless exist or different templates directory is given
      
      m.directory( default_templates_path )
      m.template("prototype.yml.rb", File.join(path, "#{singular_name}.yml"))
      
      m.migration_template("migration.rb", 'db/migrate')
      # 
      # types.each_pair do |ext, name|
      #   path = File.join("app/assets/#{name}", class_path.to_s, plural_name)
      #   m.directory( path )
      #     
      #   %w(index show new edit).each do |action|
      #     m.template("template.rb",
      #                File.join(path, "#{action}.#{ext}.erb"),
      #                :assigns => { :asset_name => name, :action => action })
      #   end
      # 
      # end
    end
  end
  
end