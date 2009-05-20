Given /^I have a model definition for "([^\"]*)" with "([^\"]*)"$/ do |model_name, model_attributes|
  # @model_definition = { model_name => YAML::load(model_attributes.gsub(', ', "\n") ) }
end

When /^this definition is loaded$/ do
  # Prototyper::Base.load(@model_definition)
  Prototyper::Base.init
end

Then /^the class "([^\"]*)" should be defined$/ do |class_name|
  @current_class = class_name
  Object.const_defined?(class_name).should be true
end

Then /^should respond to "([^\"]*)"$/ do |methods|
  class_object = @current_class.constantize

  methods.split(/, /).each do |method|
    class_object.new.should respond_to(method)
  end
  
end