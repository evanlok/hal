class Transformations
  class Scaling < Abstract
    
    def apply
      context.translate(x_origin, y_origin)
      context.scale(*scaling_values)
      context.translate(-x_origin, -y_origin)
    end

    def apply_3d
      context.scale(1,current_value) if y_axis?
      context.scale(current_value, 1) if x_axis?
      context.translate(0, -(animation.height)/2, 0) if origin.match(/bottom/)
      context.translate(0, animation.height/2, 0) if origin.match(/top/)
      context.translate(-(animation.width)/2, 0, 0) if origin.match(/right/)
      context.translate(animation.width/2, 0, 0) if origin.match(/left/)
    end

    def scaling_values
      case axis
      when :x then [current_value, 1]
      when :y then [1, current_value]
      else
        current_value
      end
    end
  end
end
