module Transitions
  class Fade < MaskedTransition

    def apply(type=:out)
      context.tint(255, 255 * reverse_progress)
    end

    def remove
      context.no_tint
      reset_coordinates
    end

    def text_apply(colors)
      colors << (255 * reverse_progress)
      context.fill(*colors)
    end

    def text_remove
      context.no_fill
    end

    def text?
      true
    end

    def calculate_current_x
      0
    end

    def calculate_current_y
      0
    end

    def apply_to_masked?
      true
    end
  end
end