Feature: Build resources dynamically
  In order to develop quickly
  As a developer 
  I want to dynamically load models
  
  Scenario: Load user model
    Given I have a model definition for "cucumber_user" with "name: string, age: integer"
    When this definition is loaded
    Then the class "CucumberUser" should be defined
      And should respond to "name, age"
    And the class "CucumberUsersController" should be defined
      And should respond to "index, destroy, show, update, edit"
    
  Scenario: Load user model
    Given I have a model definition for "cucumber_user" with "name: string, age: integer"
    When this definition is loaded
    And I go to cucumber users
    Then I should see "new cucumber_user"

