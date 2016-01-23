class Stack
  include ElementsDsl

  attr_accessor :options, :vidgenie, :out_transition, :start_time, :position, :in_transition
  attr_reader :elements

  delegate :app, :minim, :add_audio, :data_folder_path, :current_time, to: :vidgenie

  def initialize(vidgenie, options, &block)
    @vidgenie = vidgenie
    @options = options || {}
    @block = block
    @start_time = nil
    @finished = false
    @elements = []
    @started = false
    @position = nil

    @duration = options[:duration].to_f if options[:duration].present?
  end

  def play
    if @started == false
      puts "#{vidgenie.current_second.round(1)}s Stack #{@position} started (#{duration.round(2)}s)" unless ENV["RACK_ENV"] == "test"
      @started = true
    end

    if transitioning_out?
      out_transition.render(@elements, :out)
    elsif transitioning_in?
      in_transition.render(@elements, :in)
    else
      app.background(*background_color)
      @elements.map(&:render)
    end

    @finished = current_second >= duration || @elements.all? {|e| e.finished? }
    @almost_finished = @elements.all? {|e| e.finished? || e.almost_finished? }

    if @finished
      puts "#{vidgenie.current_second.round(1)}s Stack #{@position} ended" unless ENV["RACK_ENV"] == "test"
    end
  end

  def started?
    @started
  end

  def finished?
    @finished
  end

  def almost_finished?
    @almost_finished
  end

  def duration
    @duration ||= @elements.map(&:total_duration).max
  end

  def duration_with_transition
    transition_duration = out_transition ? out_transition.duration.to_i : 0
    duration - transition_duration
  end

  def end_time
    start_time + duration
  end

  def transitioning_out?
    return false unless out_transition

    current_second > (duration - out_transition.duration)
  end

  def transitioning_in?
    return false unless in_transition

    current_second < in_transition.duration
  end

  def current_second
    current_time - start_time
  end

  def evaluate
    self.instance_exec(&@block)
    set_undefined_elements_duration
  end

  def background_color
    return [255,255,255] unless options[:background].present?
    options[:background].to_s.split(",").map(&:to_i)
  end

  def set_undefined_elements_duration
    @elements.each do |element|
      if element.parent_duration?
        element.duration(duration - element._delay)
      end
    end
  end

end