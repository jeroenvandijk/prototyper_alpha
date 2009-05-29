class Object
  class << self
    def const_missing_with_prototypes(name)
      const_missing_without_prototypes(name)
    
      name.includes?
    end
  
    alias_method_chain :const_missing, :prototypes
  end
end