module Engine
  module VGL
    class Node
      attr_accessor :parent, :scope
      attr_reader :name, :args

      def initialize(name, *args)
        @name = name
        @options = args.extract_options!
        @args = args
        @children = []
        @chain = []
        @parent = nil
      end

      def add_child(node, &block)
        node.parent = self
        node.scope = block
        @children << node
      end

      def add_chain(node)
        @chain << node
      end

      def serialize
        @vgl = ""
        @vgl << %Q[node.] if @parent and @parent.scope and @parent.scope.arity > 0
        @vgl << %Q[#{@name}]

        serialize_arguments_and_options
        serialize_children
        serialize_chain

        @vgl
      end

      def serialize_arguments_and_options
        if @args.size > 0 || @options.size > 0
          @vgl << %Q[(]
          @vgl << %Q[#{serialized_arguments}] if @args.size > 0
          @vgl << ", " if @args.size > 0 and @options.size > 0
          @vgl << @options.to_s if @options.size > 0
          @vgl << %Q[)]
        end
      end

      def serialize_children
        if @children.any?
          @vgl << " do"
          @vgl << " |node|" if @scope and @scope.arity > 0
          @vgl << "\n"

          @children.each do |child|
            if serialized_child = child.serialize
              @vgl << serialized_child.split("\n").map {|l| "  #{l}" }.join("\n")
              @vgl << "\n" unless child == @children.last
            end
          end

          @vgl << "\nend"
        end
      end

      def serialized_arguments
        @args.map do |arg|
          if arg.nil?
            "nil"
          elsif arg.is_a?(Numeric) || arg.is_a?(Array)
            "#{arg}"
          elsif arg.is_a?(Symbol)
            ":#{arg}"
          elsif arg.is_a?(Range)
            "#{arg}"
          else
            "\"#{arg.gsub(/\"/, "\\\"")}\""
          end
        end.join(',')
      end

      def serialize_chain
        @chain.each do |node|
          @vgl << "." + node.serialize
        end
      end

      alias :to_vgl :serialize

      def method_missing(method, *args, &block)
        node = Node.new(method, *args)
        self.add_chain(node)
        self
      end
    end
  end
end
