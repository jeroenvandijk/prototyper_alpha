require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper'

describe Prototyper::Prototype do
  before(:each) do
    @base = Prototyper::Prototype
    @prototype = @base.new("Dummy")
  end
  
  it "#controller_name should return the correct controller name" do
    @prototype.controller_name.should eql "DummiesController"
  end
  
  it "#class_name should return the correct class name" do
    @prototype.class_name.should eql "Dummy"    
  end
  
  it "#controller_class_path should be correct" do
    @prototype.controller_class_path.should eql ""
  end
  
  it "#controller_class_name should be a plural class name" do
    @prototype.controller_class_name.should eql "Dummies"
  end
  
  
  
end