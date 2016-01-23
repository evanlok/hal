class Ellipse < Shape
  include Drawable

  def render
    render_actions do
      context.fill(*color) unless options[:color] == false
      context.stroke_weight(stroke_weight)
      context.stroke(*stroke_color) if stroke_color
      context.ellipse(*ellipse_arguments)

      unless draw_within_graphic?
        context.no_fill
        context.no_stroke
      end
    end
  end

  def ellipse_arguments
    if draw_within_graphic?
      [0,0,width,height]
    else
      [current_x, current_y, depth_adjusted_width, depth_adjusted_height]
    end
  end
  
end