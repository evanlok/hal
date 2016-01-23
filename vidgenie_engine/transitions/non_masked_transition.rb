module Transitions
  class NonMaskedTransition < Abstract

    attr_accessor :frame

    def initialize(transition)
      super

      @context = app
      @frame = 0
    end

    def render(elements, type=:out)
      apply(type)
      app.fill(*transition.stack.background_color) if transition.stack.background_color
      app.no_stroke
      app.rect(x_for(:out), y_for(:out), VidgenieEngine::WIDTH, VidgenieEngine::HEIGHT)
      elements.map(&:render)
      remove
    end

    def apply(type=:out)
      @frame = app.frame_count
    end

    def remove
      return nil unless frame == app.frame_count
      context.pop_matrix
      reset_coordinates
    end

  end
end