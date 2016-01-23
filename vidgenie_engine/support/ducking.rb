class Ducking
  
  attr_reader :from, :to,  :path
  attr_accessor :collection, :time

  def initialize(time, from, to, path=nil)
    @time = time
    @from = from
    @to = to
    @path = path
  end

  def volume_up?
    @to > @from
  end

  def volume_down?
    @from > @to
  end

  def cancels_ducking?(ducking)
    from == ducking.to && to == ducking.from
  end

  def update_volume(element)
    if (collection.voices_playing? && volume_down?) || !collection.voices_playing?
      element.duck!(self)
    end
  end

  def close_to_time?(other_time, threshold=1)
    difference = other_time.to_f - time.to_f
    difference.abs < threshold
  end

  def inspect
    "#<Ducking @to=#{to}, @time=#{time}, @from=#{from}>"
  end
end

class DuckingCollection
  include Enumerable

  attr_reader :voices

  def initialize(voices)
    @duckings = []
    @time = 0
    @voices = voices
  end

  def each
    @duckings.each {|d| yield d }
  end

  def <<(ducking)
    ducking.collection = self
    @duckings << ducking
  end

  def time=(time)
    clear_memoized_variables

    @time = time
  end

  def voices_playing
    @voices_playing ||= @voices.find_all {|v| v.playable? }
  end

  def voices_playing?
    voices_playing.any?
  end

  def current_ducking
    @current_ducking ||= @duckings.find {|d| d.close_to_time?(@time, 0.1) }
  end

  def upcoming_up_duckings
    @upcoming_up_duckings ||= @duckings.find_all {|d| current_ducking.close_to_time?(d.time) && d.volume_up? }
  end

  def sort!
    @duckings.sort_by! {|d| d.time }
  end

  private

  def clear_memoized_variables
    @voices_playing = nil
    @current_ducking = nil
    @upcoming_up_duckings = nil
  end
end