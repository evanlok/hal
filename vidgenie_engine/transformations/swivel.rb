class Transformations
  class Swivel < Abstract

    def initialize(animation, configuration, options={})
      super(animation, configuration, options={})

      @speed = @configuration[:speed] || 50
      @beta = @configuration[:beta] || 0.02
      @omega = @configuration[:omega] || 0.2
      @upsilon = @configuration[:upsilon] || 0.073
    end
    
    def apply
      context.translate(x_origin, y_origin)
      context.rotate_x(current_radians)
      context.translate(-x_origin, -y_origin)
    end

    def apply_3d
      context.rotate_x(current_radians)
    end

    def current_value
      calculate_angle(animation.current_second.to_f)
    end

    def b
      @b ||= (@beta*start_value)/(2*(@upsilon)) + (start_value/@upsilon)
    end

    def calculate_angle(time)
      return 0 if @finished
      t = time * @speed
      value = Math.exp(-(@beta/2)*t) * (start_value * Math.cos(@upsilon*t) + b * Math.sin(@upsilon*t))
      @finished = true if value.abs < 0.03
      value
    end

  end
end