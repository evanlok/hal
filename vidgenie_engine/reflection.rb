class Reflection
  include Processing::Proxy
  
  attr_reader :original, :image, :path, :opacity, :options, :position, :blur, :mask_path, :depth

  def initialize(original, path, options={})
    @original = original
    @path = path
    @options = options
    @position = options[:position] || "bottom"
    @opacity = normalize_opacity(options[:opacity] || 1)
    @depth = (options[:depth]).to_i * -1
    @blur = options[:blur]
    @mask_path = options[:mask]

    create_image
    apply_mask
  end

  def apply_mask
    return nil unless @mask_path

    @finder = FileFinder.new(@mask_path)
    @mask_file = $app.load_image(@finder.location)
    @image.mask(@mask_file)
  end

  def create_image
    @image = $app.load_image(path)
    original.load_pixels

    case position
    when "bottom" then flip_vertically
    when "top" then flip_vertically
    when "left" then flip_horizontally
    when "right" then flip_horizontally
    end

    @image.update_pixels
    @image.filter(BLUR, @blur) if @blur
  end

  def flip_vertically
    original.height.times do |column|
      new_column = original.height - column
      position = new_column * original.width - original.width
      original.width.times do |row|
        image.pixels[position+row] = original.pixels[(column*original.width + row)]
      end
    end
  end

  def flip_horizontally
    original.height.times do |row|
      position = row * original.width
      original.width.times do |column|
        image.pixels[position+original.width-column-1] = original.pixels[position+column]
      end
    end
  end

  def current_y(y, height)
    return y if ["left", "right"].include?(position)
    if position == "top"
      y-height*1.05
    elsif position == "bottom"
      y+height*1.05
    end
  end

  def current_x(x, width)
    return x if ["top", "bottom"].include?(position)
    if position == "left"
      x-width*1.05
    elsif position == "right"
      x+width*1.05
    end
  end

  def normalize_opacity(value)
    value = value.to_f / 100 if value.is_a?(String)
    value * 255
  end

  def depth?
    @depth != 0
  end
end