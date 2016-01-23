class VidgenieEngine
  module AudioDucker

    def initialize(app, options={})
      @voices = []
      @music = []

      super
    end

    def play
      duck_audio

      super
    end

    def add_audio(element)
      if element.duck_others?
        @voices << element
      else
        @music << element
      end
    end

    def update_start_time
      generate_duckings

      if ducking = @ducking_collection.first
        ducking.time = current_time
      end
    end

    def generate_duckings
      @ducking_collection = DuckingCollection.new(@voices)

      @voices.each do |element|
        time = element.start_time - (AUDIO_FADE_MS/1000)
        time = start_time if time < start_time

        @ducking_collection << Ducking.new(time, 0, element.duck_amount, element.path)
        @ducking_collection << Ducking.new(element.end_time, element.duck_amount, 0, element.path)
      end

      @ducking_collection.sort!
    end

    def duck_audio
      @ducking_collection.time = current_time
      ducking = @ducking_collection.current_ducking

      return nil if ducking.nil?

      @music.each do |element|
        ducking.update_volume(element)
      end
    end
  end
end