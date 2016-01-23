module Transitions
  class MaskedTransition < Abstract

    def initialize(transition)
      super

      @context = create_graphics(VidgenieEngine::WIDTH, VidgenieEngine::HEIGHT, P3D)
    end

    def render(elements, type=:out)
      context_setup do
        elements.each do |element|
          next unless element.respond_to?(:current_x)

          element.context = self.context
          element.forced_current_x = element.current_x - current_x
          element.forced_current_y = element.current_y - current_y
          element.render

          element.forced_current_x = nil
          element.forced_current_y = nil
        end
      end

      render_context
      reset_coordinates
    end

    def render_context
      app.push_matrix
      app.scale(0.511)
      app.translate(615,345,600)
      context.background(*transition.stack.background_color) if transition.stack.background_color

      apply if apply_to_masked?

      app.image(context, current_x, current_y, VidgenieEngine::WIDTH, VidgenieEngine::HEIGHT)
      app.pop_matrix
    end

    def context_setup
      context.begin_draw
      context.background(220, 180, 40,0)
      context.no_fill

      yield

      context.end_draw
      context
    end

    def masked?
      true
    end
  end
end