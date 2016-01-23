class Box < Animatable
  include Drawable

  attr_reader :depth
  
  def initialize(stack, x, y, z, width, height, depth, options={})
    super(stack, x, y, width, height, options)

    @start_z = z.to_i
    @depth = depth
  end

  def render_actions
    return nil unless playable?
    log_start

    context.push_matrix

    yield

    context.pop_matrix
  end

  def render
    render_actions do
      context.lights
      context.fill(*color)
      context.stroke(*stroke_color)
      context.translate(current_x, current_y, 0)
      current_animation.transformations.each {|t| t.apply_3d } if current_animation
      context.box(self.width, self.height, depth)
    end
  end
end