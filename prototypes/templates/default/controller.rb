class <%= plural_name.classify.pluralize %>Controller < ApplicationController
  make_resourceful do
    actions :all
    
    <%= "belongs_to #{as_symbols(parent_names)}" if parent_names.any? %>
  end
end