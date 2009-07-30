module Prototyper
  module Reader
    attr_reader :prototypes_definition
    
    def read(path)
      set_prototypes_definition(path)
      load(prototypes_definition)
    end
    
    def load(hash)
      prototypes = load_prototypes(hash)
      save_prototypes_definition
      
      prototypes
    end
    
    def load_previous
      load_prototypes(previous_prototypes_definition)
    end
    
    def prototypes_definition_changed?
      # prototypes_definition.diff(previous_prototypes_definition)
      prototypes_definition != previous_prototypes_definition
    end
    
    def set_prototypes_definition(path)
      prototype_definition_files = Dir[File.join(path, "*.yml")]
      hashes = prototype_definition_files.map{ |x| YAML::load_file(x) }
      @prototypes_definition = hashes.inject({}) {|result, definition| result.deep_merge(definition) }
    end
    
    def previous_prototypes_definition
      return @previous_prototype_definition if @previous_prototype_definition

      begin
        @previous_prototype_definition = YAML::load_file(previous_definition_path)
      rescue
        @previous_prototype_definition = {}
      end
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
    
    def previous_definition_path
      File.join(RAILS_ROOT, "app/prototypes", ".previous_definition.yml")
    end
    
    # TODO test this and do a smarter comparision
    def save_prototypes_definition
      if prototypes_definition_changed?
        File.open(previous_definition_path, 'w') {|f| f.write(prototypes_definition.to_yaml) }
      end
    end
    

    
  end
end