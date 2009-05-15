# TODO eval routes template, so that it can be reused
ActionController::Routing::Routes.draw do |map|
  Prototyper::Base.prototypes.each do |prototype| 
    if prototype.child_names.empty?
      map.resources prototype.name.pluralize
    else
      map.resources prototype.name.pluralize do |resource|
        prototype.child_names.each do |child_name|
          resource.resources child_name.pluralize
        end
      end
      
    end
    
  end
end