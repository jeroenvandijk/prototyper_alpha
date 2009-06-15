require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper'

describe Prototyper::Association do
  before(:each) do
    @base = Prototyper::Association
    @name = 'users'
    @type = 'has_many'
    @association ={ @type => @name }
  end

  describe "::VALID_OPTIONS" do
    it "should contain all options" do
      @base::VALID_OPTIONS.should eql %w(as through)
    end
  end
  
  describe "with valid options" do    
    before(:each) do
      @options = { 'as' => 'other_users', 'through' => 'memberships' }
    end
    
    subject { @base.new(@options.merge(@association)) }
    specify { proc{ subject }.should_not raise_error }    
    
    it "should set name correctly" do
      subject.name.should eql @name
    end
    it "should set type correctly" do
      subject.type.should eql @type
    end
    
    it "should return the correct set of options" do
      subject.options.should == @options
    end
    
    it "should return a valid options string" do
      eval("{:dummy_to_use_the_comma => 1 #{subject.options_string}}").should == {:dummy_to_use_the_comma => 1, :as => :other_users, :through => :memberships}
    end
  end
  
  describe "without options" do
    subject { @base.new(@association) }
    specify { proc{ subject }.should_not raise_error }    

    it "#options_string should return nil" do
      subject.options_string.should be nil
    end
  end

  
  describe "with invalid options" do
    subject { @base.new(@association.merge('as' => 'other_users', 'invalid' => 'option')) }
    specify { proc{ subject }.should raise_error }    
  end  
  
  describe "#child?" do    
    it "should return true with has_many" do
      assoc = @base.new('has_many' => 'users')
      assoc.child?.should == true
    end
    
    it "should return true with has_one" do
      assoc = @base.new('has_one' => 'user')
      assoc.child?.should == true
    end
    
    it "should return true with has_and_belongs_to_many" do
      assoc = @base.new('has_and_belongs_to_many' => 'users')
      assoc.child?.should == true
    end
  end
  
  describe "#parent?" do    
    it "should return false with has_many without options" do
      assoc = @base.new('has_many' => 'users')
      assoc.parent?.should == false
    end
    
    it "should return true with has_many :through" do
      assoc = @base.new('has_many' => 'users', 'through' => 'foo')
      assoc.parent?.should == true
    end
    
    it "should return false with has_one" do
      assoc = @base.new('has_one' => 'user')
      assoc.parent?.should == false
    end
    
    it "should return true with belongs_to" do
      assoc = @base.new('belongs_to' => 'user')
      assoc.parent?.should == true
    end
    
    it "should return true with has_and_belongs_to_many" do
      assoc = @base.new('has_and_belongs_to_many' => 'users')
      assoc.parent?.should == true
    end
  end
  
end