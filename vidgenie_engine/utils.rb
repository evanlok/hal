module Utils
  extend self
  
  def to_pixels(percent, axis, total=nil)
    total = axis == :width ? VidgenieEngine::WIDTH : VidgenieEngine::HEIGHT unless total
    (percent.to_f * total)/100
  end

  def print_error_and_backtrace(e)
    puts "\nError: #{e.inspect}"
    puts "Backtrace: \n"
    e.backtrace.each {|b| puts b }
    puts "\n"
  end
end

class String

  def to_pixels(axis, total=nil)
    Utils.to_pixels(self, axis, total)
  end
end

class Numeric

  def to_pixels(axis, total=nil)
    self
  end
end

class NilClass

  def to_pixels(axis, total=nil)
    0
  end
end