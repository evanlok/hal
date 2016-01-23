class Element

  attr_reader :stack
  attr_accessor :_delay, :_duration, :context
  attr_writer :playable

  delegate :vidgenie, to: :stack
  
  def initialize(stack)
    @stack = stack
    @_delay = 0
    @_duration = 0
    @finished = false
    @almost_finished = false
    @playable = nil
    @started = false
    @parent_duration = false
    @grandparent_duration = false
    @context = stack.is_a?(Element) ? stack.stack.app : stack.app
  end

  def identifier
  end

  def delay(seconds)
    @_delay = seconds.to_f
    self
  end

  def duration(seconds)
    if seconds.to_s.match(/^\+/)
      @_duration += seconds.to_s.gsub(/^\+/, "").to_f
    else
      @_duration = seconds.to_f
    end

    @parent_duration = true if seconds == ".."
    @grandparent_duration = true if seconds == "..."
    self
  end

  def parent_duration?
    @parent_duration
  end

  def grandparent_duration?
    @grandparent_duration
  end

  def render
    raise NotImplementedError.new("All subclasses of Element must override #render.")
  end

  def finished?
    @finished
  end

  def almost_finished?
    @almost_finished
  end

  def playable?
    return @playable unless @playable.nil?
    !mark_as_finished && current_time >= start_time
  end

  def end_time
    start_time + _duration
  end

  def start_time
    stack.start_time + _delay
  end

  def total_duration
    _delay + _duration
  end

  def current_time
    stack.current_time
  end

  def current_second
    current_time - start_time
  end

  def log_start
    if @started == false
      puts "#{vidgenie.current_second.round(2)}s #{self.class} #{self.identifier} started (#{_duration.round(2)}s) #{log_options}" unless ENV["RACK_ENV"] == "test"
      @started = true
    end
  end

  def log_options
  end

  private

  def mark_as_finished
    return true if @finished == true
    
    @finished = true if current_time >= end_time
    @almost_finished = true if current_time >= (end_time - 0.05)

    false
  end

  def render_actions
    return nil unless playable?
    log_start
    yield
  end
end