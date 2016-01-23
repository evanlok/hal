class VidgenieEngine
  module SketchControls
    
    def initialize(app, options={})
      @paused = false
      @paused_time = 0.0
      @last_pause_at = 0.0

      super
    end

    def current_time
      if @paused
        @last_pause_at
      else
        real_current_time - @paused_time
      end
    end

    def pause!
      @last_pause_at = current_time
      @paused = true
    end

    def resume!
      @paused = false
      @paused_time += (current_time - @last_pause_at)
    end

    def toggle_play!
      if @paused
        self.resume!
        puts "Resuming. Last paused at: #{@last_pause_at}, total paused for: #{@paused_time}, real current time: #{real_current_time}\n\n"
      else
        puts "\n\nPausing. real current time: #{real_current_time}, simulated curren time :#{current_time}, total paused for: #{@paused_time}"
        self.pause!
      end
    end
  end
end