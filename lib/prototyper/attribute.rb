module Prototyper
  class Attribute
    attr_reader :name, :meta_type
  
    def initialize(name, meta_type)
      @name, @meta_type = name, meta_type
    end
  
    def type
      return meta_type if native?
      # TODO Do something smart when the meta type isn't the same as native and a String isn't enough
      "string"
    end
  
    def native?
      Prototype.native_attribute_types.include?(meta_type)
    end
  end
end