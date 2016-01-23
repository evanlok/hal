module Transitions
  class SlideDown < MaskedTransition

    def calculate_current_x
      0
    end

    def calculate_current_y
      progress * VidgenieEngine::HEIGHT
    end
  end
end