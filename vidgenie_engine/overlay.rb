class Overlay < Animatable
  include ElementsDsl

  delegate :vidgenie, :app, :transitioning_out?, :out_transition, to: :stack
  delegate :minim, :add_audio, :data_folder_path, to: :vidgenie
  
  def initialize(stack, x, y, width, height, options={}, &block)
    super(stack, x, y, width, height, options)

    @elements = []
    @element_index = 0
    self.instance_exec(&block)
    @duration_set = false
  end

  def identifier
  end

  def render
    set_elements_duration if current_time >= start_time and !@duration_set

    render_actions do
      @elements.each do |element|
        element.context = self.context
        element.forced_current_x = self.current_x + element.current_x
        element.forced_current_y = self.current_y + element.current_y
        element.depth = self.depth if depth?
        element.playable = true
        element.render

        element.forced_current_x = nil
        element.forced_current_y = nil
      end
    end
  end

  def set_elements_duration
    @elements.each do |element|
      element._duration = _duration
      element._delay = _delay
    end

    @duration_set = true
  end
end