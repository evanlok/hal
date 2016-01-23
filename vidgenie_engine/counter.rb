class Counter < Text

  attr_reader :counter_duration, :counter_delay

  def initialize(stack, text, x, y, width, height, options={})
    super(stack, text, x, y, width, height, options)
    @text = @text.to_f.round(1)
    @counter_duration = options[:duration] if options[:duration]
    @counter_delay = options[:delay].to_f.round(1)
    @_duration = @counter_duration if @counter_duration.to_i > @_duration.to_i
  end

  def text
    (@text * counter_progress).to_f.round(1).to_s
  end

  def counter_current_second
    current_second - counter_delay
  end

  def counter_progress
    return 0 if counter_current_second < 0
    return 1 if counter_current_second > counter_duration
    counter_current_second.to_f.round(1) / counter_duration
  end
end
