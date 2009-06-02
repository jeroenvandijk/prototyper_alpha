module ConstMissingExtension
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def const_missing(name)
      klass = nil
      begin
        klass = super
      rescue NameError
        raise unless Prototyper::Base.has_definition_for?(name)
      end

      klass ||= Prototyper::Base.define(name) if Prototyper::Base.has_definition_for?(name)
      
      klass
    end
  end
  
end

Object.send :include, ConstMissingExtension