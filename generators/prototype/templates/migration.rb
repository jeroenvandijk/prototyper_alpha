class SetupPrototypes < ActiveRecord::Migration
  def self.up
    for_each_prototype do |name, fields|
      create_table(name.tableize) do |t|
        fields.each do |field|
          t.column field, :string
        end
      end
    end
  end

  def self.down
    for_each_prototype do |name, fields|
      drop_table(name.tableize)
    end
  end
  
  def self.for_each_prototype
    
    prototypes = YAML::load_file( File.join(RAILS_ROOT, "app/prototypes", "user.yml" ) )
    
    prototypes.each_pair do |name, fields|
      yield(name, fields)
    end
  end
  
end