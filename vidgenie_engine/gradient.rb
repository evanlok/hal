class Gradient < Animatable
  include Processing::Proxy

  attr_reader :colors, :axis, :type

  def initialize(stack, x, y, width, height, options={})
    super(stack, x, y, width, height, options)

    @colors = options.delete(:colors)
    @axis = options.delete(:axis) || :y
    @type = options.delete(:type) || :linear
    @radius = options.delete(:radius) || 10

    self.image
  end

  def image
    @image ||= begin
      image = $app.create_image(width, height, RGB)
      image = draw_linear_gradient(image) if @type == :linear
      image = draw_radial_gradient(image) if @type == :radial
      image
    end
  end

  def render
    render_actions do
      image.mask(@mask_object.render) if @mask_object
      context.image(self.image, current_x, current_y, depth_adjusted_width, depth_adjusted_height)
    end
  end

  private

  def draw_linear_gradient(img)
    img.load_pixels
    img.pixels.size.times do |i|
      img.pixels[i] = $app.lerp_color(start_color, end_color, gradient_progress(i))
    end
    img.update_pixels
    img
  end

  def draw_radial_gradient(img)
    img.load_pixels
    img.pixels.size.times do |i|
      img.pixels[i] = end_color
    end

    @radius.times do |r|
      color = $app.lerp_color(start_color, end_color, r.to_f/@radius)
      set_pixel_color(img, start_x, start_y + r, color)
      set_pixel_color(img, start_x, start_y - r, color)
      set_pixel_color(img, start_x + r, start_y, color)
      set_pixel_color(img, start_x - r, start_y, color)

      f = 1 - r
      ddF_x = 1
      ddF_y = -2 * r
      x = 0
      y = r
      while x < y
        if f >= 0
          y -= 1
          ddF_y += 2
          f += ddF_y
        end
        x += 1
        ddF_x += 2
        f += ddF_x
        set_pixel_color(img, start_x + x, start_y + y, color)
        set_pixel_color(img, start_x + x, start_y - y, color)
        set_pixel_color(img, start_x - x, start_y + y, color)
        set_pixel_color(img, start_x - x, start_y - y, color)
        set_pixel_color(img, start_x + y, start_y + x, color)
        set_pixel_color(img, start_x + y, start_y - x, color)
        set_pixel_color(img, start_x - y, start_y + x, color)
        set_pixel_color(img, start_x - y, start_y - x, color)
      end
    end

    img.update_pixels
    img
  end

  def image_pixels_size
    @image_pixels_size ||= width * height
  end

  def set_pixel_color(img, x, y, color)
    position = (x*width + y).to_i
    return nil if position > image_pixels_size || position < 0
    img.pixels[position] = color
  end

  def gradient_progress(index)
    if axis == :x
      (index % width)/width.to_f
    else
      (index/height) / height.to_f
    end
  end

  def start_color
    @start_color ||= $app.color(*color_value(colors[0]))
  end

  def end_color
    @end_color ||= $app.color(*color_value(colors[-1]))
  end

  def color_value(color)
    return [0,0,0] unless color
    color.split(",").map(&:to_i)
  end
end