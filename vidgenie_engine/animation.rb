class Animation
  attr_reader :element, :delay, :start_x, :start_y, :end_x, :end_y, :options, :transformations

  delegate :current_time, :width, :height, to: :element
  
  def initialize(element, delay, start_x, start_y, end_x, end_y, options={})
    @parent_width = element.stack.respond_to?(:width) ? element.stack.width : VidgenieEngine::WIDTH
    @parent_height = element.stack.respond_to?(:height) ? element.stack.height : VidgenieEngine::HEIGHT

    @element = element
    @delay = delay

    @start_x = start_x.to_pixels(:width, @parent_width)
    @start_y =  start_y.to_pixels(:height, @parent_height)
    @end_x = end_x.to_pixels(:width, @parent_width)
    @end_y = end_y.to_pixels(:height, @parent_height)
    @options = options
    @options[:duration] ||= 1

    @transformations = Transformations.new(self, options)
  end

  def animate!(options={})
    return nil unless @transformations.active?

    element.context.push_matrix unless options[:matrix] == false

    @transformations.each do |transformation|
      transformation.apply if transformation.transform?
    end
  end

  def undo
    return nil unless @transformations.active?

    element.context.no_tint     if @transformations.opacity.transform?
    element.context.pop_matrix
  end

  def finished?
    current_time >= end_time
  end

  def current_x
    return end_x if finished?
    Easing.send(easing_function, current_second, @start_x, change_in_value_x, duration)
  end

  def current_y
    return end_y if finished?
    Easing.send(easing_function, current_second, @start_y, change_in_value_y, duration)
  end

  def duration
    @duration ||= options[:duration]
  end

  # === Animation control options
  #

  def start_time
    element.start_time + delay
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
    @change_in_value_x ||= (@end_x - @start_x)
  end

  def change_in_value_y
    @change_in_value_y ||= (@end_y - @start_y)
  end

  def easing_function
    @easing_function ||= (options[:easing] || "ease_out_cubic")
  end

  def inspect
    "#<Animation:#{self.object_id} @element=#<#{element.class}#{element.object_id}> current_x=#{current_x}, current_y=#{current_y}, duration=#{duration}, progress=#{progress}, current_second=#{current_second}, transformations=[#{transformations.map(&:class)}]"
  end
end