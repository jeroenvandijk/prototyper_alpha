require File.dirname(__FILE__) + '/spec_helper'

describe Object do
  describe "#const_missing" do
    it "should call Prototyper::Base when prototype exists" do
      Prototyper::Base.stubs(:prototypes => [Prototyper::Prototype.new("an_existing_prototype")])
  
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
    
    it "should return the static declared class as last" do
      pending("Don't know how to test this yet, Rails does this automatically via active_support with load_paths and override of const_missing")
    end
    
    it "should always call define when prototype exists" do
      pending("Don't know how to tests this because it requires usage of rails const_missing implementation")
    end
  end

end