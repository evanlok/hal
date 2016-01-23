module Transitions
  class PushDown < NonMaskedTransition

    def apply(type=:out)
      context.push_matrix
      context.translate(0, y_for(type))

      super
    end

    def calculate_current_x
      0
    end

    def in_current_y
      current_y - VidgenieEngine::HEIGHT
    end

    def calculate_current_y
      progress * VidgenieEngine::HEIGHT
    end
  end
end