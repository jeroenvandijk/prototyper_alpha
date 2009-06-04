class <%= singular_name.classify %> < ActiveRecord::Base 
  # Associations
  <%= pretty_print(associations) %>

  # Semantic attributes
  <%= semantic_attributes(attributes) %>
end
