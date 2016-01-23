class Sequence < Element
  include ElementsDsl

  delegate :vidgenie, :app, :transitioning_out?, :out_transition, to: :stack
  delegate :minim, :add_audio, :data_folder_path, to: :vidgenie
  
  def initialize(stack, &block)
    super(stack)

    @elements = []
    @element_index = 0
    self.instance_exec(&block)

    set_elements_delay

    @_duration = @elements.map(&:total_duration).max
  end

  def identifier
  end

  def render
    render_actions do
      @elements.each(&:render)
    end
  end

  private

  def set_elements_delay
    delay = 0

    @elements.each_with_index do |element, index|
      element_delay = element._delay + delay
      delay += element._duration + element._delay
      element._delay = element_delay
    end
  end
end