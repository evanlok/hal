#
# The Animatable class defined any kind of element that can be animated within a Vidgenie Video
# it provides the follwing abilities:
#
# === Easing: 
# Move a element from a starting point (x,y) to a ending point. The animation supports 
# a variety of easing functions.
#   - linear
#   - ease_in_quad
#   - ease_out_quad
#   - ease_in_out_quad
#   - ease_in_cubic
#   - ease_out_cubic
#   - ease_in_out_cubic
#   - ease_in_quart
#   - ease_out_quart
#   - ease_in_out_quart
#   - ease_in_quint
#   - ease_out_quint
#   - ease_in_out_quint
#   - ease_in_sine
#   - ease_out_sine
#   - ease_in_out_sine
#   - ease_in_expo
#   - ease_out_expo
#   - ease_in_out_expo
#   - ease_in_circ
#   - ease_out_circ
#   - ease_in_out_circ
#   - ease_out_bounce
#
# * To see all easing functions in action go to: {http://easings.net/ http://easings.net/}
#
# === Rotation
# Rotate a element between two specified angles.
#
# === Animatable elements
# The currently animatable elements are:
# - movie
# - image
# - overlay
#
# === Units
# The values with which to build the elements can be specified in both pixels and percentages
# of the screen size.
# 
class Animatable < Element
  include VidgenieEngine::Debugger
  include DepthAdjustment

  attr_reader :width, :height, :options, :start_x, :start_y, :animations
  attr_writer :forced_current_x, :forced_current_y
  
  def initialize(stack, x, y, width, height, options={})
    @parent_width = stack.respond_to?(:width) ? stack.width : VidgenieEngine::WIDTH
    @parent_height = stack.respond_to?(:height) ? stack.height : VidgenieEngine::HEIGHT

    @start_x = x.to_pixels(:width, @parent_width )
    @start_y = y.to_pixels(:height, @parent_height )
    @width = width.to_pixels(:width, @parent_width )
    @height = height.to_pixels(:height, @parent_height )

    @options = options || {}
    @animations = []
    @animation_index = 0

    @current_x = nil
    @current_y = nil

    @depth = (options.delete(:depth) || 0).to_i

    super(stack)
  end

  def identifier
  end

  def log_options
    statement = "X: #{current_x.to_i}, Y: #{current_y.to_i}"

    if depth? and ENV['APP_ENV'] != "production"
      real_x = context.screen_x(current_x, current_y, -depth)
      real_y = context.screen_y(current_x, current_y, -depth)
      statement << ", RX: #{real_x.round.to_i}, RY: #{real_y.to_i}, "
    end
    statement
  end

  def attributes
    {x: current_x, y: current_y, w: width, h: height, o: options, dn: _duration, dl: _delay}
  end

  # Transitions an element from it's starting point to the coordinates specified
  # 
  # @param [ Integer, String ] x The ending coordinate on the X axis. It assumes pixels for a Integer
  #   and percentage for a String.
  # @param [ Integer, String ] y The ending coordinate on the Y axis. It assumes pixels for a Integer
  #   and percentage for a String.
  # @param [ Hash ] options
  # 
  # @option options [ Integer ] :duration Number of seconds for the transition
  # @option options [ String ] :easing Name of the easing function
  # @option options [ Integer, Range ] :rotate Degrees the element will rotate
  # @option options [ Integer, Range ] :scale Percentage of the actual size (1 is the original size)
  # @option options [ Integer, Range ] :opacity Percentage where 1 is full opacity and 0 is invisible
  # @option options [ Integer, Range ] :shear_x Degress the element with shearX
  # @option options [ Integer, Range ] :shear_y Degress the element with shearY
  # @option options [ Integer, Range ] :rotate_x Degress the element will rotate on X
  # @option options [ Integer, Range ] :rotate_y Degress the element will rotate on Y
  # @option options [ Integer, Range ] :rotate_z Degress the element will rotate on Z
  #
  def animate(end_x, end_y, options={})
    @animations << Animation.new(self, animations_duration, last_animation_end_x, last_animation_end_y, end_x, end_y, options)
    @_duration = animations_duration
    self
  end

  def render
    raise NotImplementedError.new("All subclasses of Animatable must override #render.")
  end

  def current_x
    return @forced_current_x if @forced_current_x
    @current_x ||= begin
      x = calculate_current_x
      x -= width if options[:align].to_s.match(/right/)
      x
    end
  end

  def calculate_current_x
    return last_animation_end_x unless current_animation

    current_animation.current_x
  end

  def current_y
    return @forced_current_y if @forced_current_y
    @current_y ||= begin
      y = calculate_current_y
      y -= height if options[:align].to_s.match(/bottom/)
      y
    end
  end

  def calculate_current_y
    return last_animation_end_y unless current_animation

    current_animation.current_y
  end

  def x_origin
    calculate_origin(:x, {"center" => -0.5, "right" => -1})
  end

  def y_origin
    calculate_origin(:y, {"center" => -0.5, "bottom" => -1})
  end

  def calculate_origin(axis, mappings)
    origin = options[:"#{axis}_origin"] || options[:origin]
    method = axis == :x ? "width" : "height"
    return nil unless origin

    if multiplier = mappings[origin]
      send(method) * multiplier
    else
      nil
    end
  end

  def current_animation
    @animations[@animation_index]
  end

  def reset_cached_coordinates
    @current_x = nil
    @current_y = nil
  end

  private

  def animations_duration
    @animations.inject(0) {|sum, animation| sum + animation.duration}
  end

  def last_animation_end_x
    @animations.last ? @animations.last.end_x : @start_x
  end

  def last_animation_end_y
    @animations.last ? @animations.last.end_y : @start_y
  end

  def move_to_next_animation
    @animation_index += 1
  end

  def render_actions
    super do
      generate_dimensions
      
      current_animation.animate! if current_animation

      if x_origin || y_origin
        context.push_matrix
        context.translate(x_origin.to_i, y_origin.to_i)
      end

      context.translate(0,0, -depth) if depth?

      yield

      context.translate(0,0, depth) if depth?

      if x_origin || y_origin
        context.pop_matrix
      end
      
      if current_animation
        current_animation.undo
        move_to_next_animation if current_animation.finished?
      end

      reset_cached_coordinates
    end
  end
end