class Transformations
  class DimensionRotation < Abstract
    
    def apply
      context.translate(x_origin, y_origin)
      context.send(processing_method, current_radians)
      context.translate(-x_origin, -y_origin)
    end

    def apply_3d
      context.send(processing_method, current_radians)
    end

    def processing_method
      "rotate_#{axis}"
    end
  end
end