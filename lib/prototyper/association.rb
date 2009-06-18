module Prototyper
  class Association
    attr_reader :name, :type, :options

    SYMBOL_OPTIONS = %w(as through)
    OTHER_OPTIONS = %W(polymorphic)
    OPTIONS = SYMBOL_OPTIONS + OTHER_OPTIONS
  
    def initialize(hash)
      @options = hash.reject { |option, _| !OPTIONS.include? option }
      
      pair = (hash.to_a - @options.to_a).flatten

      raise "wrong number of arguments for the definition of this association #{pair.inspect}" unless pair.length == 2

      @type, @name = pair
    end

    def parent?
      %w(belongs_to has_and_belongs_to_many).include?(type) || 
        !!(type == "has_many" && options['through'])
    end
  
    def child?
      %w(has_many has_one has_and_belongs_to_many).include?(type)
    end

    # Returns the options as symbols without the '{}' parentheses
    def options_string
      SYMBOL_OPTIONS.each {|key| @options[key] = @options[key].to_sym if @options[key] }
      ", " + options.symbolize_keys.inspect[1..-2].gsub('=>', ' => ') unless options.empty?
    end
  end
end