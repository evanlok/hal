class VidgenieEngine
  module FrameRateLogger

    def play
      track_frame_rate

      super
    end
    
    def track_frame_rate
      frame_count = app.frame_count.to_i
      return nil if frame_count < FRAME_RATE

      frame_rate = app.frame_rate.to_i

      @frame_collector ||= {}
      @frame_collector[frame_count] = frame_rate if frame_rate < (FRAME_RATE - 10)

      @total_frames ||= []
      @total_frames << frame_count

      log_frame_rate("great", 25, frame_rate, frame_count)
      log_frame_rate("acceptable", 15, frame_rate, frame_count)
    end

    def log_frame_rate(name, min, rate, count)
      last_frame = self.instance_variable_get("@last_#{name}_frame") || 0

      if rate < min and (count - last_frame) >= FRAME_RATE/2
        puts "Frame rate below #{name} threshold: fps= #{rate}, frame: #{count}"
        self.instance_variable_set("@last_#{name}_frame", count)
      end
    end

    def total_frames_captured
      Array(@total_frames).size
    end

    def frames_missing
      ideal_frame_count - total_frames_captured
    end

    def ideal_frame_count
      (current_time * FRAME_RATE)
    end

    def frames_lost_per_second
      frames_missing.to_f / current_time
    end

    def lowest_frame_rate
      @frame_collector ||= {}
      @frame_collector.values.sort.first
    end
  end
end