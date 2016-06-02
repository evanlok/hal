class VideoResolutions
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def low
    [width / 3, height / 3]
  end

  def medium
    [width / 2, height / 2]
  end

  def high
    [width, height]
  end

  def json
    {
      low: low,
      medium: medium,
      high: high
    }
  end
end
