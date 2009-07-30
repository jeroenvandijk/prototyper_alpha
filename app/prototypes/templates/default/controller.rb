class <%= plural_name.classify.pluralize %>Controller < ResourceController
  <%= parent_names.map{|x| "belongs_to :#{x}" }.join("\n  ") if parent_names.any? %>
  
  <%= "options " + prototype_options.map{ |x| "#{x.first.inspect} => #{x.second.inspect}" }.join(", ") if prototype_options.present? %>
end
