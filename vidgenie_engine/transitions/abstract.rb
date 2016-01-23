module Transitions
  class Abstract
    include Processing::Proxy

    attr_reader :transition, :context
    
    def initialize(transition)
      @transition = transition
    end

    def app
      transition.stack.app
    end

    def progress
      transition.progress
    end

    def reverse_progress
      1 - progress
    end

    def apply(type=:out)
      raise NotImplementedError.new("All subclasses of Transitions::Abstract must override #apply.")
    end

    def remove
      raise NotImplementedError.new("All subclasses of Transitions::Abstract must override #remove.")
    end

    def text?
      false
    end

    def current_x
      @current_x ||= calculate_current_x
    end

    def current_y
      @current_y ||= calculate_current_y
    end

    def reset_coordinates
      @current_x = nil
      @current_y = nil
    end

    def x_for(type)
      type == :out ? current_x : in_current_x
    end

    def y_for(type)
      type == :out ? current_y : in_current_y
    end

    def apply_to_masked?
      false
    end

    def masked?
      false
    end
  end
end