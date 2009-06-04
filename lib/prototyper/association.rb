module Prototyper
  class Association
    attr_reader :name, :type, :options
  
    ASSOCIATION_TYPES = %w(has_many has_one belongs_to has_and_belongs_to_many)
    PARENT_ASSOCIATIONS = %w(belongs_to has_and_belongs_to_many)
    CHILD_ASSOCIATIONS = ASSOCIATION_TYPES - PARENT_ASSOCIATIONS
    VALID_OPTIONS = %w(as through)
  
    def initialize(hash)
      @options = hash.reject { |option, _| !VALID_OPTIONS.include? option }
    
      pair = (hash.to_a - @options.to_a).flatten

      raise "wrong number of arguments for the definition of this association #{pair.inspect}" unless pair.length == 2

      @type, @name = pair
    end

    def parent?
      PARENT_ASSOCIATIONS.include?(type)
    end
  
    def child?
      CHILD_ASSOCIATIONS.include?(type)
    end
  
    # Returns the options as symbols without the '{}' parentheses
    def options_string
      ", " + options.symbolize_keys.inspect[1..-2].gsub('=>', ' => ') unless options.empty?
    end
  end
end