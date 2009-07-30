class <%= singular_name.classify %> < ActiveRecord::Base 
  # Associations
  <%= pretty_print(associations) %>

  # Semantic attributes
  <%= semantic_attributes(attributes) %>

  <% if attributes.map(&:name).include?("name") %>
  def to_param; [id, name].join("-"); end
  <% end %>
    
  <%= "concerned_with #{concerns.map(&:inspect).join(", ")}" if concerns.any? %>
  
end
