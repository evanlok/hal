module Transitions
  class PushRight < NonMaskedTransition

    def apply(type=:out)
      context.push_matrix
      context.translate(x_for(type), 0)

      super
    end

    def in_current_x
      current_x - VidgenieEngine::WIDTH
    end

    def calculate_current_x
      progress * VidgenieEngine::WIDTH
    end

    def calculate_current_y
      0
    end
  end
end