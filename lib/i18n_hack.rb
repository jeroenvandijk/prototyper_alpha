module ActionView
  class Base
    # class << self
      def translate_with_context(*args)
        raise args.inspect + "test"
      end
      alias_method_chain :translate, :context
    # end
  end
end
