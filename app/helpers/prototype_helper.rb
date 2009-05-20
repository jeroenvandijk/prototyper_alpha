module PrototypeHelper
  def list_of_prototypes
    items = Prototyper::Base.prototypes.map do |prototype| 
      if prototype.child_names.empty?
        prototype.name.pluralize
      else
        prototype.name.pluralize + content_tag(:ul, listing(prototype.child_names.map { |child| link_to child, send("#{child}_path") }) )
      end
    end
    listing(items)
  end
  
  def listing_of(items)
    items.map { |x| content_tag(:li, x) }
  end
  
  
end