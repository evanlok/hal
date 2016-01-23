class Transformations
  class Depth < Abstract
    
    def apply
      context.translate(0,0, -current_value)
    end
  end
end
