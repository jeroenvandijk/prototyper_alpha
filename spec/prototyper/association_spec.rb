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
      subject.options_string.should eql %{, :as => "other_users", :through => "memberships"}
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
  
end