require File.dirname(__FILE__) + '/spec_helper'

describe "hacked translation" do
  it "should return a hacked translation" do
    ActionView::Base.new.t("tessdft") == "testf"
  end
  


end