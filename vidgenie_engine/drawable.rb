module Drawable
  
  def color
    rgb = color_value(options[:color])

    if current_animation and current_animation.transformations.opacity.transform?
      rgb << current_animation.transformations.opacity.current_opacity
    elsif options[:opacity]
      rgb << (options[:opacity].to_f * 255)
    end
    
    rgb
  end

  def stroke_color
    return nil unless options[:stroke_color]
    color_value(options[:stroke_color])
  end

  def stroke_weight
    options[:stroke_weight] || 1
  end

  private

  def color_value(color)
    return [0,0,0] unless color
    color.split(",").map(&:to_i)
  end
end