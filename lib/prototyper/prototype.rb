module Prototyper
  class Prototype
    attr_reader :name, :namespaces

    def initialize(name, properties = {}, options = {})
      @name = (name == name.pluralize ? name.singularize : name)
      @raw_attributes   = properties['attributes']   || []
      @raw_associations = properties['associations'] || []
      @namespaces   = options['namespaces']      || []
    end

    # Returns all the attributes
    def attributes
      @attributes ||= @raw_attributes.map { |x| Attribute.new(*x.to_a.first) }
    end

    # Returns all the associations
    def associations
      @associations ||= @raw_associations.map { |x| Association.new(x) }
    end
    
    def belongs_to_associations
      @belongs_to_associations ||= associations.select { |x| x.type == "belongs_to" }
    end
    
    # Returns the names of the parent resources
    def parent_names
      @parent_names ||= associations.select{|x| x.parent?}.map(&:name)
    end
    
    # Returns the names of the child resources
    def child_names
      @child_names ||= associations.select{|x| x.child?}.map(&:name)
    end

    # Returns a hash with variable mappings (name-value) that can be assigned to templates
    # The assigned locals are compatible with locals in Rails scaffold templates.
    def to_locals
      return @to_locals if @to_locals
      
      @to_locals = {
        # Support of rails templates
        :singular_name => name.singularize,
        :plural_name => name.pluralize,
        :attributes => attributes,
        # Extended
        :parent_names => parent_names,
        :associations => associations,
        :required_attributes => [],
        # GLOBALS
        :NATIVE_ATTRIBUTE_TYPES => self.class.native_attribute_types
      }
    end
    
    # TODO get from active record
    def self.native_attribute_types
      %w(primary_key string text integer float decimal datetime timestamp time date binary boolean)
    end
    
    class Attribute
      attr_reader :name, :meta_type
      
      def initialize(name, meta_type)
        @name, @meta_type = name, meta_type
      end
      
      def type
        return meta_type if Prototype.native_attribute_types.include?(meta_type)
        # TODO Do something smart when the meta type isn't the same as native and a String isn't enough
        "string"
      end
    end
    
    class Association
      attr_reader :name, :type, :options
      
      ASSOCIATION_TYPES = %w(has_many has_one belongs_to has_and_belongs_to_many)
      PARENT_ASSOCIATIONS = %w(belongs_to has_and_belongs_to_many)
      CHILD_ASSOCIATIONS = ASSOCIATION_TYPES - PARENT_ASSOCIATIONS
      
      
      def initialize(hash)
        @options = hash.delete("options")
        pair = hash.to_a.flatten
        
        raise "wrong number of arguments for the definition of this association #{pair.inspect}" unless pair.length == 2

        @name , @type = pair
      end

      def parent?
        PARENT_ASSOCIATIONS.include?(type)
      end
      
      def child?
        CHILD_ASSOCIATIONS.include?(type)
      end
      
      # Returns the options as symbols without the '{}' parentheses
      def options_string
        ", " + options.symbolize_keys.inspect[1..-2].gsub('=>', ' => ') if options
      end
    end
    
  end
end