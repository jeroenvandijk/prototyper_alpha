require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper'

describe Prototyper::Base do
  before(:each) do
    @base = Prototyper::Base
  end
  
  describe "#prototype_definition_changed?" do
    it "should return true when definition changed" do
      @base.stubs(:prototypes_definition =>  { 1 => 3 }, :previous_prototypes_definition => { 1 => 4 })
      @base.prototypes_definition_changed?.should be true
    end
  
    it "should return false when definition is the same" do
      @base.stubs(:prototypes_definition => { 1 => 2 }, :previous_prototypes_definition => { 1 => 2 })
      @base.prototypes_definition_changed?.should be false
    end
  end
  
  describe "#load" do
    it "should return an array of prototypes" do
      @base.stubs(:save_prototypes_definition)
      @base.load('models' => { 'user' => { 'attributes' => { 'name' => 'string' } } }).size.should be 1
    end
    
  end

  
end