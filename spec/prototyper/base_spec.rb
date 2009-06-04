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
  
  describe "#define" do
    describe "when a prototype 'example' exists" do
      before(:each) do
        @prototype = Prototyper::Prototype.new("example")
        @base.stubs(:prototypes => [@prototype])
      end
      # Following specs test whether a class is defined. There is probably a better way
      it "should return a class named 'Example'" do
        @base.define('Example').to_s.should eql "Example"
      end
      
      it "should return a class named 'ExamplesController'" do
        @base.define('ExamplesController').to_s.should eql "ExamplesController"
      end
      
      it "should return nil for 'another_example'" do
        @base.define('AnotherExampleController').to_s.should eql ""
      end
      
      
      
    end
    
  end
  
  describe "#has_definition_for" do
    %w(example mail_template job_opening_reaction).each do |prototype_name|
     describe "when a prototype '#{prototype_name}' exists" do
       before(:each) do
         @base.stubs(:prototypes => [Prototyper::Prototype.new(prototype_name)])
       end

       it "should return true for '#{prototype_name.pluralize.camelize}Controller'" do
         @base.has_definition_for?("#{prototype_name.pluralize.camelize}Controller").should be true
       end

       it "should return true for '#{prototype_name.camelize}'" do
         @base.has_definition_for?("#{prototype_name.camelize}").should be true
       end
     end
   end
       
    
  end
  
  describe "#cleanup_prototypes" do
    it "should clean up all created models and controllers" do
      @base.stubs(:prototypes => [Prototyper::Prototype.new("example_prototype")])
      @base.define("ExamplePrototype")
      @base.cleanup_prototypes
      Object.const_defined?("ExamplePrototype").should be false
    end
    
    it "should give no error when a prototype has not been defined yet because rails can interfere as well" do
      @base.stubs(:prototypes => [Prototyper::Prototype.new("example_prototype")])
      @base.define("ExamplePrototype")
      Object.instance_eval { remove_const "ExamplePrototype" }
      proc{ @base.cleanup_prototypes }.should_not raise_error
    end
    
    
    
  end

  
end