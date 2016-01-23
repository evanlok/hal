class InnerStack < Element
  include ElementsDsl

  delegate :vidgenie, :app, :transitioning_out?, :out_transition, :minim, :add_audio, to: :stack
  
  def initialize(stack, options={}, &block)
    super(stack)

    @elements = []
    self.instance_exec(&block)

    @_duration = @elements.map(&:total_duration).max
    set_undefined_elements_duration
  end

  def identifier
  end

  def render
    render_actions do
      @elements.each(&:render)
    end
  end

  def set_undefined_elements_duration
    @elements.each do |element|
      if element.parent_duration?
        element.duration(@_duration)
      elsif element.grandparent_duration?
        element.duration(100)
      end
    end
  end

  def playable?
    true
  end
end