module PrototypesHelper
  
  def list_of_prototypes
    items = Prototyper::Base.prototypes.map do |prototype| 
      link_to(prototype.name, send("#{prototype.name.pluralize}_path") )
    end
    listing_of(items)
  end
  
  def listing_of(items)
    items.map { |x| content_tag(:li, x) }
  end
  
end