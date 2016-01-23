class Line < Shape
  include Drawable

  def initialize(stack, x1, y1, x2, y2, options = {})
    @x1, @y1, @x2, @y2 = x1, y1, x2, y2
    super(stack, x1, y1, width, height, options)
  end

  def width
    @width ||= begin
      sorted_x = [@x1, @x2].sort
      sorted_x.last - sorted_x.first
    end
  end

  def height
    @height = 0
  end

  def render
    render_actions do
      context.fill(*color) unless options[:color] == false
      context.stroke_weight(stroke_weight)
      context.stroke(*stroke_color) if stroke_color
      context.line(*line_arguments)

      unless draw_within_graphic?
        context.no_fill
        context.no_stroke
      end
    end
  end

  def line_arguments
    [@x1, @y1, @x2, @y2]
  end
end
