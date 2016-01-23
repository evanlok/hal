class Mask < Animatable
  include ElementsDsl
  include Processing::Proxy

  delegate :vidgenie, :app, :transitioning_out?, :out_transition, to: :stack

  attr_reader :stack, :graphic, :elements

  def initialize(stack_or_image, form, x, y, width, height, options={}, &block)
    super(stack_or_image, x, y, width, height, options)

    @form = form
    if block_given?
      @graphic = create_graphics(self.width, self.height, P3D)
      @block = true 
      @elements = []
      @element_index = 0
      self.instance_exec(&block)
      @duration_set = false
      @_duration = @elements.map(&:total_duration).max
    else
      @image_width = stack_or_image.file.width
      @image_height = stack_or_image.file.height
      @image_width_ratio = @image_width.to_f / stack_or_image.width
      @image_height_ratio = @image_height.to_f / stack_or_image.height
      @graphic = create_graphics(@image_width, @image_height, P3D)
    end
  end

  def render
    set_elements_duration if current_time >= start_time and !@duration_set

    if @block
      graphic_setup do
        render_actions do
          @elements.each do |element|
            element.context = graphic

            if options[:relative_position] == false
              element.forced_current_x = element.current_x - current_x
              element.forced_current_y = element.current_y - current_y
            end

            element.render

            element.forced_current_x = nil
            element.forced_current_y = nil
          end

          self.context.image(graphic, current_x, current_y, depth_adjusted_width, depth_adjusted_height)
        end
      end
    else
      draw_graphic
    end
  end

  def draw_graphic
    graphic_setup do
      if current_animation
        current_animation.transformations.each do |transformation|
          transformation.context = graphic
          transformation.apply
        end
      end

      graphic.send(form_method, graphic_x, graphic_y, graphic_width, graphic_height)

      self.reset_cached_coordinates
    end
  end

  def active?
    return true if @block
    return true if current_animation and !current_animation.finished?
    return true if self.current_x > 0 || self.current_y > 0
    return true if self.width < stack.width || self.height < stack.height
    false
  end

  def graphic_x
    self.current_x * @image_width_ratio.to_f
  end

  def graphic_y
    self.current_y * @image_height_ratio.to_f
  end

  def graphic_width
    self.width * @image_width_ratio.to_f
  end

  def graphic_height
    self.height * @image_height_ratio.to_f
  end

  def graphic_setup
    graphic.begin_draw
    graphic.background(0,0)
    graphic.fill(255)
    # graphic.smooth(8)
    graphic.textMode(MODEL)

    yield

    graphic.end_draw
    graphic
  end

  def form_method
    return @form if [:rect, :ellipse].include?(@form)
    :rect
  end

  def set_elements_duration
    Array(@elements).each do |element|
      element._duration = _duration if element._duration == 0
      # element._delay = _delay + element._delay
    end

    @duration_set = true
  end
end