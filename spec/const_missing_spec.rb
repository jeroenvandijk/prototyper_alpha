require File.dirname(__FILE__) + '/spec_helper'

describe Object do
  describe "#const_missing" do
    it "should call Prototyper::Base when prototype exists" do
      Prototyper::Base.stubs(:has_definition_for?).returns(true)
      Object.expects(:const_missing)
      
      # Stub the definition of the class, don't know how to do it other than to actually change the class
      Prototyper::Base.class_eval do
        def self.define(name)
          eval("class AnExistingPrototype; end")
        end
      end      
      
      lambda { AnExistingPrototype }.should_not raise_error
      AnExistingPrototype.to_s.should eql "AnExistingPrototype"
      
    end
  
    it "should raise when prototype does not exist" do
      lambda { ANoneExistingPrototype }.should raise_error(NameError)
    end
    
    it "should not raise when the object already exists" do
      lambda { String }.should_not raise_error
    end
    
    it "should return the constant when it exists" do
      String.to_s.should eql "String"
    end
  end

end