module Prototyper
  module Reader
    def read(path)
      prototypes_definition = YAML::load_file(path)
      load(prototypes_definition)
    end
    
    def load(hash)
      compare_with_previous(hash)
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
    
    # TODO test this and do a smarter comparision
    def compare_with_previous(definition)
      previous_path = File.join(RAILS_ROOT, "app/prototypes", ".previous_definition.yml")
      
      begin
        @prototype_definition_has_changed = YAML::load_file(previous_path) != definition
      rescue
        @prototype_definition_has_changed = true
      end
      
      if prototype_definition_changed?
        File.open(previous_path, 'w') {|f| f.write(definition.to_yaml) }
      end
    end
    
    def prototype_definition_changed?
      @prototype_definition_has_changed
    end
    
  end
end