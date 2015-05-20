module Engine
  module VGL
    class Builder
      # The current Document object being built
      attr_accessor :document

      # The parent of the current node being built
      attr_accessor :parent

      def initialize
        @document = Node.new('sketch', {})
        @parent = @document

        yield self
      end

      def method_missing(method, *args, &block)
        method = :nil_node if [:audio, :image].include?(method) and args.first.blank?
        node = Node.new(method, *args)
        insert(node, &block)
        node
      end

      def insert(node, &block)
        return nil if node.name == :nil_node

        @parent.add_child(node, &block)
        node.parent = @parent

        if block_given?
          old_parent = @parent
          @parent = node
          block.call(self)
          @parent = old_parent
        end
      end

      def to_vgl
        @document.serialize
      end
    end
  end
end
