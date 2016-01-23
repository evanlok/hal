class VideoPlayer < Animatable

  attr_reader :path, :movie

  def initialize(stack, path, x, y, width, height, options={})
    super(stack, x || 0, y || 0, width || stack.app.width, height || stack.app.height, options)

    @path = path
    finder = FileFinder.new(@path)
    
    @movie = ::Sketch::Movie.new(context, finder.location)
    @movie.frame_rate(30)
    @movie.play
    @movie.jump(0)
    @_duration = @movie.duration
    @movie.pause

    @playing = false
    @stopped = false
  end

  def identifier
    @path
  end

  def stop
    @movie.stop
    @stopped = true
  end

  def render
    if stack.current_time >= end_time && !@stopped
      self.stop
    end

    render_actions do
      unless @playing
        @movie.play
        @playing = true
      end

      if @movie.available? and !@stopped
        @movie.read
        @movie.volume(options[:volume].to_f) if options[:volume].present?
      end

      # @movie.mask(@mask_object.render) if @mask_object
      context.image(@movie, current_x, current_y, depth_adjusted_width, depth_adjusted_height)
    end
  end

  def mask(form, x,y, width, height, options={})
    @mask_object = Mask.new(self, form, x, y, width, height, options)
  end
end