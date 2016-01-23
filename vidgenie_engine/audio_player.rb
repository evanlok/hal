class AudioPlayer < Element
  
  attr_reader :path, :audio, :metadata, :duck_amount
  attr_accessor :current_ducking

  def initialize(stack, path, options={})
    super(stack)

    @path = path
    @load_as_file = options[:file]
    @audio = load_audio_file
    @duck_amount = options[:duck] == true ? -10 : options[:duck].to_i
    @metadata = @audio.get_meta_data
    @_duration = (metadata.length.to_f/1000)
    @current_ducking = 0
    @volume = options[:volume]
    @playing = false
    @stopped = false

    stack.add_audio(self) if VidgenieEngine.ancestors.include?(VidgenieEngine::AudioDucker)
  end

  def identifier
    @path
  end

  def render
    # stop if current_time >= end_time and !@stopped
    return nil if !playable? || @stopped

    render_actions do
      play if current_time >= start_time and !@playing
    end
  end

  def stop
    return nil if @stopped
    audio.close
    @stopped = true
  end

  def play
    audio.set_gain(@volume) if @volume
    @load_as_file ? @audio.play : @audio.trigger
    @playing = true
  end

  def duck_others?
    @duck_amount != 0
  end

  def duck!(ducking)
    return if @current_ducking == ducking.to

    audio.shift_gain(@current_ducking, ducking.to, VidgenieEngine::AUDIO_FADE_MS)
    @current_ducking = ducking.to
  end

  def load_audio_file
    finder = FileFinder.new(@path)

    begin
      if @load_as_file
        stack.minim.load_file(finder.location)
      else
        stack.minim.load_sample(finder.location, 10240)
      end

    rescue Java::JavaLang::NullPointerException => e
      raise VidgenieEngine::FileNotFound.new("The audio path #{finder.location} is not available.")
    end
  end
end
