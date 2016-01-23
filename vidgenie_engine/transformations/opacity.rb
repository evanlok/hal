class Transformations
  class Opacity < Abstract
    
    def apply
      context.tint(255, current_opacity)
    end

    def apply_3d
      apply
    end

    def current_opacity
      (start_value + ((end_value - start_value) * animation.progress)) * 255
    end
  end
end
