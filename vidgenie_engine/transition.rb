require 'vidgenie_engine/transitions/abstract'
require 'vidgenie_engine/transitions/masked_transition'
require 'vidgenie_engine/transitions/non_masked_transition'
require 'vidgenie_engine/transitions/push_left'
require 'vidgenie_engine/transitions/push_right'
require 'vidgenie_engine/transitions/push_up'
require 'vidgenie_engine/transitions/push_down'
require 'vidgenie_engine/transitions/fade'
require 'vidgenie_engine/transitions/slide_left'
require 'vidgenie_engine/transitions/slide_right'
require 'vidgenie_engine/transitions/slide_up'
require 'vidgenie_engine/transitions/slide_down'

# Represents a transition between 2 stacks. 
# Currently the transition object is only aware of the 
# previous stack so we aren't able to apply a transitioning
# effect to the underlying stack.
#
# === Transition Effects
# The following transition effects are supported
#   - Fade
#   - SlideLeft
#   - SlideRight
#   - SlideUp
#   - SlideDown
#
class Transition

  attr_reader :stack, :effect, :duration, :context
  attr_accessor :in_transition
  
  def initialize(stack, effect, duration, options={})
    @stack = stack
    @duration = duration

    @effect = Transitions.const_get(effect).new(self)
    @stack.out_transition = self
  end

  def progress
    return 1.0 if stack.current_time >= stack.end_time

    current_second.to_f / duration
  end

  def current_second
    stack.current_second - (stack.duration - duration)
  end

  def masked?
    @masked ||= effect.masked?
  end

  def render(elements, type=:out)
    effect.render(elements, type)
  end
end