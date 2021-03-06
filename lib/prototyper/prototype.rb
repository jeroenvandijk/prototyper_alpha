module Prototyper
  class Prototype

    ACCESSORS = [ :name, 
                  :namespaces,
                  :controller_class_path,
                  :controller_file_name,
                  :controller_class_name,
                  :required_attributes,
                  :class_name,
                  :singular_name,
                  :plural_name,
                  :class_path,
                  :associations,
                  :parent_names,
                  :attributes,
                  :concerns,
                  :prototype_options ]

    attr_reader *ACCESSORS

    def initialize(name, properties = {}, options = {})
      @namespaces   = options['namespaces']      || []
      @raw_attributes   = properties['attributes']   || []
      @raw_associations = properties['associations'] || []
      @prototype_options = (properties['options'] || {}).symbolize_keys

      raise "The property 'attributes' for prototype #{name} should be an array" unless @raw_attributes.is_a? Array
      raise "The property 'associations' for prototype #{name} should be an array" unless @raw_associations.is_a? Array

      # inflections
      @singular_name = @name = (name == name.pluralize ? name.singularize : name)
      @plural_name = singular_name.pluralize

      @class_path = ""
      @file_name = @singular_name
      @controller_file_name = @plural_name
      @controller_class_path = namespaces.join("/")
      @class_name = [@controller_class_path, @singular_name].reject{|x| x.blank? }.join("/").camelize
      @controller_class_name = @class_name.pluralize
      @required_attributes = []
    end

    # Returns all the attributes
    def attributes
      @attributes ||= @raw_attributes.map { |x| Attribute.new(*x.to_a.first) }
    end
    
    def prototype_options
      @prototype_options
    end
    
    # Returns all defined concerns as symbols
    #   prototype = Prototype.new("test", "concerned_with" => ["validations", "attributes"])
    #   prototype.concerns #=> [:validations, :attributes]
    def concerns
      @concerns ||= Dir["app/models/#{name}_concerns/*.rb"].map{|x| File.basename(x, ".rb").to_sym }
    end

    # Returns all the associations
    def associations
      @associations ||= @raw_associations.map { |x| Association.new(x) }
    end
    
    def belongs_to_associations
      @belongs_to_associations ||= associations.select { |x| x.type == "belongs_to" }
    end
    
    def habtm_associations
      @habtm_associations ||= associations.select { |x| x.type == "has_and_belongs_to_many" }
    end
    
    
    # Returns the names of the parent resources
    def parent_names
      @parent_names ||= associations.select{|x| x.parent?}.map{|x| x.name.singularize}
    end
    
    # Returns the names of the child resources
    def child_names
      @child_names ||= associations.select{|x| x.child?}.map(&:name)
    end

    # Returns a hash with variable mappings (name-value) that can be assigned to templates
    # The assigned locals are compatible with locals in Rails scaffold templates.
    def to_locals
      @to_locals ||= ACCESSORS.inject({}) { |result, field| result[field] = self.send(field); result }
    end
    
    def controller_name
      "#{controller_class_name}Controller"
    end
    
    # TODO get from active record
    def self.native_attribute_types
      %w(primary_key string text integer float decimal datetime timestamp time date binary boolean)
    end
  end
end