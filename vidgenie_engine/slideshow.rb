class Slideshow < Sequence  
  attr_accessor :paths, :x, :y, :image_width, :image_height, :options, :block

  def initialize(stack, paths, x, y, width, height, options={}, &block)
    @paths = paths
    @x = x
    @y = y
    @image_width = width
    @image_height = height
    @options = options
    @block = block

    super(stack, &images_block)

    @_duration = @elements.map(&:total_duration).max
  end

  def images_block
    Proc.new do
      paths.each do |path|
        image = image(path, x, y, image_width, image_height, image_options)
        block.call(image)
      end
    end
  end

  def set_elements_delay
    delay = 0
    @elements.each_with_index do |element, index|
      element._delay += delay
      delay += delay_between_images
    end
  end

  def delay_between_images
    @delay_between_images ||= options[:delay].to_f
  end

  def image_options
    valid_options = [:origin, :x_origin, :y_origin, :blur, :reflection]
    Hash[options.map {|k,v| [k,v] if valid_options.include?(k) }.compact]
  end

end