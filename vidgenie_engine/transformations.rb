require "vidgenie_engine/transformations/abstract"
require "vidgenie_engine/transformations/opacity"
require "vidgenie_engine/transformations/rotation"
require "vidgenie_engine/transformations/scaling"
require "vidgenie_engine/transformations/shear"
require "vidgenie_engine/transformations/dimension_rotation"
require "vidgenie_engine/transformations/swivel"
require "vidgenie_engine/transformations/depth"

class Transformations
  include Enumerable

  OPTIONS = [:opacity, :rotate, :scale, :scale_x, :scale_y, :shear_x, :shear_y, 
              :rotate_x, :rotate_y, :rotate_z, :swivel, :depth]

  attr_reader :animation, :options

  def initialize(animation, options={})
    @animation = animation
    @options = options
    @active = []

    options.each do |key, value|
      @active << send(key) if OPTIONS.include?(key)
    end
  end

  def active?
    @active.any? { |t| t.transform? }
  end

  def each(&block)
    @active.each(&block)
  end

  def depth
    @depth ||= Transformations::Depth.new(animation, options[:depth])
  end

  def swivel
    @swivel ||= Transformations::Swivel.new(animation, options[:swivel])
  end

  def opacity
    @opacity ||= Transformations::Opacity.new(animation, options[:opacity])
  end

  def rotate
    @rotate ||= Transformations::Rotation.new(animation, options[:rotate])
  end

  def scale
    @scale ||= Transformations::Scaling.new(animation, options[:scale])
  end

  def scale_x
    @scale_x ||= Transformations::Scaling.new(animation, options[:scale_x], axis: :x)
  end

  def scale_y
    @scale_y ||= Transformations::Scaling.new(animation, options[:scale_y], axis: :y)
  end

  def shear_x
    @shear_x ||= Transformations::Shear.new(animation, options[:shear_x], axis: :x)
  end

  def shear_y
    @shear_y ||= Transformations::Shear.new(animation, options[:shear_y], axis: :y)
  end

  def rotate_x
    @rotate_x ||= Transformations::DimensionRotation.new(animation, options[:rotate_x], axis: :x)
  end

  def rotate_y
    @rotate_y ||= Transformations::DimensionRotation.new(animation, options[:rotate_y], axis: :y)
  end

  def rotate_z
    @rotate_z ||= Transformations::DimensionRotation.new(animation, options[:rotate_z], axis: :z)
  end
end