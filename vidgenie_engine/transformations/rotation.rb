class Transformations
  class Rotation < Abstract
    
    def apply
      context.translate(x_origin, y_origin)
      context.rotate(current_radians)
      context.translate(-x_origin, -y_origin)
    end

    def apply_3d
      context.rotate(current_radians)
    end

    def default_origin
      "center"
    end
  end
end