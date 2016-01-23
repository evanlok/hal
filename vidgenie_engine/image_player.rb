class ImagePlayer < Animatable
  include Processing::Proxy

  attr_reader :path, :file

  def initialize(stack, path, x, y, width=nil, height=nil, options={})
    @stack = stack
    @path = path

    @context = stack.app
    @finder = FileFinder.new(@path)
    @file = load_file

    @max_width = options[:max_width].to_pixels(:width) if options[:max_width]
    @max_height = options[:max_height].to_pixels(:height) if options[:max_height]

    @width = calculate_dimension(:width, width, height)
    @height = calculate_dimension(:height, width, height)

    @flip = options.delete(:flip)

    restrict_max_dimensions

    super(stack, x, y, @width, @height, options)

    generate_reflection
    apply_transformations
    apply_filters
  end

  def identifier
    @path
  end

  def load_file
    @file = context.load_image(@finder.location)
    raise VidgenieEngine::FileNotFound.new("The image path #{@finder.location} is not available.") unless @file
    @file
  end

  def calculate_dimension(axis, width, height)
    return @file.send(axis) if width.nil? && height.nil?
    return width if width and axis == :width
    return height if height and axis == :height

    if axis == :width
      height = height.to_pixels(:height)
      height * ratio
    else
      width = width.to_pixels(:width)
      width / ratio
    end
  end

  def restrict_max_dimensions
    if @max_width and @width >= @max_width
      @width = @max_width
      @height = @width / ratio
    end

    if @max_height and @height >= @max_height
      @height = @max_height
      @width = @height * ratio
    end
  end

  def ratio
    @file.width.to_f / @file.height.to_f
  end

  def render
    render_actions do
      begin
        @file.mask(@mask_object.render) if @mask_object and @mask_object.active?
        context.image(@file, current_x, current_y, depth_adjusted_width, depth_adjusted_height)
        render_reflection
      rescue Java::JavaLang::NullPointerException => e
        raise VidgenieEngine::FileNotFound.new("The image path #{@finder.location} is not available.")
      end
    end
  end

  def apply_filters
    @file.filter(BLUR, options[:blur]) if options[:blur]
  end

  def apply_transformations
    if [:horizontally, :vertically].include?(@flip)
      @transformed = $app.create_image(@file.width, @file.height, RGB)
      @file.load_pixels
      @transformed.load_pixels
      send("flip_#{@flip}")
      @transformed.update_pixels
      @file = @transformed
    end
  end

  def flip_vertically
    @file.height.times do |column|
      new_column = @file.height - column
      position = new_column * @file.width - @file.width
      @file.width.times do |row|
        @transformed.pixels[position+row] = @file.pixels[(column*@file.width + row)]
      end
    end
  end

  def flip_horizontally
    @file.height.times do |row|
      position = row * @file.width
      @file.width.times do |column|
        @transformed.pixels[position+@file.width-column-1] = @file.pixels[position+column]
      end
    end
  end

  def generate_reflection
    return nil unless options[:reflection]
    @reflection = Reflection.new(@file, @finder.location, options[:reflection])
  end

  def render_reflection
    return nil unless @reflection
    context.tint(255, @reflection.opacity.to_i)
    context.translate(0,0,@reflection.depth) if @reflection.depth
    context.image(@reflection.image, @reflection.current_x(current_x, width), @reflection.current_y(current_y, height), width, height)
    context.no_tint
    context.translate(0,0,-@reflection.depth) if @reflection.depth
  end

  def mask(form_or_path, x=nil,y=nil, width=nil, height=nil, options={})
    if form_or_path.is_a?(String) and form_or_path.match(/\.jpg|\.png|\.jpeg/)
      begin
        @finder = FileFinder.new(form_or_path)
        @mask_file = self.context.load_image(@finder.location)
        @file.mask(@mask_file)
        self
      rescue StandardError => e
        puts "Error when applying the mask: #{e.inspect}"
      end
    else
      @mask_object = Mask.new(self, form_or_path, x, y, width, height, options)
    end
  end
end