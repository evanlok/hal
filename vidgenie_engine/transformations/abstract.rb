class Transformations
  class Abstract
    include Processing::Proxy

    attr_reader :animation, :start_value, :end_value, :options, :axis, :configuration, :origin
    attr_writer :context

    def initialize(animation, configuration, options={})
      @animation = animation
      @options = options
      @axis = options[:axis] || nil
      @configuration = configuration

      @configuration = {value: @configuration, origin: default_origin} unless @configuration.is_a?(Hash)
      @origin = @configuration[:origin] || default_origin

      parse_values(@configuration[:value])
    end

    def context
      @context || animation.element.context
    end

    def default_origin
      "top-left"
    end

    def transform?
      @transform
    end

    def current_value
      start_value + ((end_value - start_value) * animation.progress)
    end

    def current_radians
      $app.radians(current_value)
    end

    def x_origin
      value = animation.current_x
      value += animation.width if @origin.match(/right/)
      value += animation.width/2 if @origin.match(/-center/) || @origin == "center"
      value
    end

    def y_origin
      value = animation.current_y
      value += animation.height if @origin.match(/bottom/)
      value += animation.height/2 if @origin.match(/\Acenter/)
      value
    end

    def x_axis?
      @axis == :x || @axis.nil?
    end

    def y_axis?
      @axis == :y || @axis.nil?
    end

    def parse_values(value)
      return nil unless value

      if value.is_a?(Range)
        @start_value = value.first
        @end_value = value.last
      else
        @start_value = value
        @end_value = value
      end

      @transform = true
    end

    def apply
      raise NotImplementedError.new("All subclasses of Transformations::Abstract must override #apply.")
    end

    def apply_3d
      raise NotImplementedError.new("All subclasses of Transformations::Abstract must override #apply_3d.")
    end
  end
end