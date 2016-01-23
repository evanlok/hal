class Triangle < Shape
  include Drawable

  def initialize(stack, x1, y1, x2, y2, x3, y3, options = {})
    @x1, @y1, @x2, @y2, @x3, @y3 = x1, y1, x2, y2, x3, y3
    super(stack, x1, y1, width, height, options)
  end

  def width
    @width ||= begin
      sorted_x = [@x1, @x2, @x3].sort
      sorted_x.last - sorted_x.first
    end
  end

  def height
    @height ||= begin
      sorted_y = [@y1, @y2, @y3].sort
      sorted_y.last - sorted_y.first
    end
  end

  def render
    render_actions do
      context.fill(*color) unless options[:color] == false
      context.stroke_weight(stroke_weight)
      context.stroke(*stroke_color) if stroke_color
      context.triangle(*triangle_arguments)

      unless draw_within_graphic?
        context.no_fill
        context.no_stroke
      end
    end
  end

  def triangle_arguments
    [@x1, @y1, @x2, @y2, @x3, @y3]
  end
end
