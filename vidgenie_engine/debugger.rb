class VidgenieEngine
  module Debugger
    extend ActiveSupport::Concern

    def debugging_enabled?
      vidgenie.debugging_enabled? || debug?
    end

    def debug?
      options[:debug] == true
    end

    def debug_color
      @debug_color ||= [(rand * 255).to_i, (rand * 255).to_i, (rand * 255).to_i]
    end

    def debug_bounding_box
      context.push_matrix
      context.stroke(*debug_color)
      context.no_fill

      if self.respond_to?(:draw_within_graphic?) and draw_within_graphic?
        main_context.rect(current_x, current_y, width, height)
      else
        context.rect(current_x, current_y, width, height)
      end
      
      unless context.is_a?(Java::ProcessingOpengl::PGraphics3D)
        context.text_size(14)
        context.text("#{width.round(1)}x#{height.round(1)}", current_x, current_y)
        context.text("X: #{current_x.round(1)}, Y: #{current_y.round(1)}", current_x, current_y + 20)
      end
      context.pop_matrix
    end

    def render_actions
      super do
        yield

        if debugging_enabled?
          debug_bounding_box
        end
      end
    end
  end
end