module Prototyper
  module Routes
    
    def routes_for_prototypes
      Base.prototypes.each do |prototype| 
        if prototype.child_names.empty?
          resources prototype.name.pluralize

        else
          resources prototype.name.pluralize do |resource|
            prototype.child_names.each do |child_name|
              resource.resources child_name.pluralize
            end
          end
        end    
      end
    end
    
  end
end