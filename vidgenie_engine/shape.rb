class Shape < Animatable
  include Processing::Proxy

  attr_reader :main_context
  
  def initialize(stack, x, y, width, height, options={})
    super(stack, x, y, width, height, options)

    if draw_within_graphic?
      @main_context = @context
      @context = create_graphics(self.width, self.height, P3D)
    end
  end

  def render_actions
    return nil unless playable?
    log_start
    debug_bounding_box if debugging_enabled?

    generate_dimensions
    
    context_setup do      
      current_animation.animate!(matrix: !draw_within_graphic?) if current_animation

      context.translate(0,0, -depth) if depth?

      yield

      context.translate(0,0, depth) if depth?

      if current_animation
        current_animation.undo unless draw_within_graphic?
        move_to_next_animation if current_animation.finished?
      end
    end

    if draw_within_graphic?
      main_context.image(context, current_x, current_y, width, height)
    end
  end

  def draw_within_graphic?
    @draw_within_graphic ||= !!options[:gradient]
  end

  private

  def context_setup(options={})
    if draw_within_graphic?
      options = {background: 255, fill: 255}.merge(options)
      context.begin_draw
      context.background(0,0)
    end

    yield

    if draw_within_graphic?
      context.end_draw
    end
  end
end