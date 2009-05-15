require File.expand_path(File.join(File.dirname(__FILE__) + "/prototyper/base") )

# require "prototyper/base"
# require "prototyper/prototype"
# Prototyper


# Models - load templates and fill these in with the yaml file

# Controllers - load templates and fill these with the yaml file

# Routes are defined in config/routes.rb (dynamically) if no such route exist. Possible?

# Don't load views, but render them dynamically from the templates if a template does not exist (this saves memory i guess). 
# For this we need to override the render engine i guess.

# Migrations should be made dynamically if an equivalent does not exist. They should also be ran dynamically.

# Tests 
# Only create tests when the prototypes are exported. Make use of shoulda and cucumber.

# Name should be a name


# Yaml definition:
# fields and associations
# Define what fields are for which views, required fields, types.
# Define how much records should be loaded.

# Set helpers in config files such as list_of

# Use semantic attributes to correctly display and validates attributes.
# Use ajax validation to give direct feedback when filling in forms based on the attributes.