module Transitions
  class SlideLeft < MaskedTransition

    def calculate_current_x
      progress * -VidgenieEngine::WIDTH
    end

    def calculate_current_y
      0
    end
  end
end