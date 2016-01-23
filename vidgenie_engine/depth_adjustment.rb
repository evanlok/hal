module DepthAdjustment
  extend ActiveSupport::Concern

  included do
    attr_reader :depth
  end

  def depth=(value)
    @depth = value
    @depth_adjusted_width = nil
    @depth_adjusted_height = nil
  end
  
  def depth?
    @has_depth ||= @depth != 0
  end

  def depth_font_adjustment
    @depth_font_adjustment ||= 0.1*depth
  end

  def depth_x_adjustment
    @depth_x_adjustment ||= width*0.1*depth
  end

  def depth_y_adjustment
    @depth_y_adjustment ||= height*0.1*depth
  end

  def depth_adjusted_width
    @depth_adjusted_width ||= depth? ? adjusted_width : width
  end

  def depth_adjusted_height
    @depth_adjusted_height ||= depth? ? adjusted_height : height
  end

  def real_x1
    context.screen_x(current_x, current_y, -depth)
  end

  def real_y1
    context.screen_y(current_x, current_y, -depth)
  end

  def real_x2
    context.screen_x(current_x+width, current_y+height, -depth)
  end

  def real_y2
    context.screen_y(current_x+width, current_y+height, -depth)
  end

  def adjusted_width
    width * (width/(real_x2-real_x1).to_f)
  end

  def adjusted_height
    height * (height/(real_y2-real_y1).to_f)
  end

  def generate_dimensions
    depth_adjusted_width
    depth_adjusted_height
  end
end