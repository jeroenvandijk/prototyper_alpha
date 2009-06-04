module Prototyper
  class Migrator
  
    def self.install()   migrate(:up)   end
    def self.uninstall() migrate(:down) end
    def self.reinstall
      uninstall
      install
    end
    
    def self.migrate(direction)
      PrototypesMigration.verbose = false
      PrototypesMigration.migrate(direction)
    end
  
    class PrototypesMigration < ActiveRecord::Migration
      class << self
        delegate :prototypes, :previous_prototypes, :to => Base
      end
      
      # TODO make the migration code reusable for export of features
      # TODO add support for habtm associations
      def self.up
        prototypes.each do |prototype|
          create_table(prototype.name.tableize) do |t|
            t.belongs_to *prototype.belongs_to_associations.map(&:name) if prototype.belongs_to_associations.any?
            
            prototype.attributes.each do |attribute|
              t.column attribute.name, attribute.type
            end
            t.timestamps
            
          end
        end
      end

      def self.down
        previous_prototypes.each do |prototype|
          table_name = prototype.name.tableize
          drop_table(table_name) if table_exists?(table_name)
        end
      end

    end
  
  end
end