module Prototyper
  module Reader
    def read(path)
      prototypes_definition = YAML::load_file(path)
      load_prototypes(prototypes_definition)
    end
    
    def load(hash)
      load_prototypes(hash)
    end
    
    private
    
    def load_prototypes(hash, namespaces = [])
      prototypes = []

      # first handle all normal models
      if models_hash = hash["models"]
        models_hash.each_pair do |model_name, model_properties|
          prototypes << Prototype.new(model_name, model_properties, :namespaces => namespaces)
        end
      end

      # go into recursion to handle the models under a namespace
      if found_namespaces = hash["namespaces"]
        found_namespaces.each_pair do |namespace, models_under_namespace|
          prototypes += load_prototypes(prototypes_under_namespace, namespaces + [namespace])
        end
      end

      prototypes
    end

  end
end