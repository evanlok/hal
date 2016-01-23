class Transformations
  class Shear < Abstract
    
    def apply
      context.translate(x_origin, y_origin)
      context.send(processing_method, current_radians)
      context.translate(-x_origin, -y_origin)
    end

    def apply_3d
      context.send(processing_method, current_radians)
    end

    def processing_method
      axis == :x ? "shear_x" : "shear_y"
    end
  end
end