class CustomShape < Animatable
  include Drawable
  include Processing::Proxy

  attr_reader :vertices
  
  def initialize(stack, x, y, options={}, &block)
    super(stack, x, y, "100", "100", options)

    @p_shape = create_shape
    @vertices = []
    self.instance_exec(&block)
  end

  def vertex(x, y, z)
    Vertex.new(self, x, y, z).tap do |vertex|
      @vertices << vertex
    end
  end

  def render
    render_actions do
      @p_shape.begin_shape
      @p_shape.fill(*color) if color

      @vertices.each do |vertex|
        if vertex.active?
          @p_shape.vertex(*vertex.coordinates)
        end
      end

      @p_shape.end_shape(CLOSE)
      context.lights
      context.shape(@p_shape, current_x, current_y)
    end
  end
end

class Vertex

  attr_reader :x, :y, :z, :shape, :animation

  def initialize(shape, x, y, z)
    @shape = shape
    @x, @y, @z = x, y, z
    @animation = nil
  end

  def animate(x, y, z, options={})
    @animation = VertexAnimation.new(self, x, y, z, options)
  end

  def coordinates
    return [x, y, z] unless @animation
    animation.coordinates
  end

  def active?
    return true unless @animation
    animation.active?
  end

end

class VertexAnimation

  attr_reader :vertex, :x, :y, :z, :options, :duration, :delay
  
  def initialize(vertex, x, y, z, options)
    @vertex = vertex
    @x, @y, @z = x, y, z
    @options = options
    @duration = options.delete(:duration).to_i
    @delay = options.delete(:delay).to_i
  end

  def active?
    current_time >= start_time
  end

  def coordinates
    [current_x, current_y, current_z]
  end

  def current_x
    return x if finished?
    Easing.send("linear", current_second, vertex.x, change_in_value_x, duration)
  end

  def current_y
    return y if finished?
    Easing.send("linear", current_second, vertex.y, change_in_value_y, duration)
  end

  def current_z
    return z if finished?
    Easing.send("linear", current_second, vertex.z, change_in_value_z, duration)
  end

  # === Animation control options
  #
  def finished?
    current_time >= end_time
  end

  def start_time
    vertex.shape.start_time + delay
  end

  def current_time
    vertex.shape.current_time
  end

  def end_time
    start_time + duration
  end

  def progress
    return 1.0 if finished?

    current_second.to_f / duration
  end

  def current_second
    current_time - start_time
  end

  def change_in_value_x
    @change_in_value_x ||= (x - vertex.x)
  end

  def change_in_value_y
    @change_in_value_y ||= (y - vertex.y)
  end

  def change_in_value_z
    @change_in_value_z ||= (z - vertex.z)
  end

end