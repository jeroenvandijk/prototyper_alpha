# Use this file to prevent too much clutter in the templates and make things DRY

def as_symbols(list)
  list.map(&:to_sym).inspect[1..-2]
end

def pretty_print(associations)
  associations.sort_by(&:name).map do |association|
    "#{association.type} :#{association.name}#{association.options_string}"
  end.join("\n" + indent)
end

# Declares attributes using the semantic attributes plugin
def semantic_attributes(attributes)
  attributes.inject([]) do |semantics, attribute|
    semantics << %{#{attribute.name}_is_#{an attribute.meta_type}} unless NATIVE_ATTRIBUTE_TYPES.include?(attribute.meta_type)
    semantics
  end.join("\n" + indent)
end

def an(meta_type)
  article = meta_type[0..0] =~ /[aehiou]/ ? "an" : "a"
  [article, meta_type].join('_')
end

def indent(level = nil)
  level ||= 1
  "  " * level
end