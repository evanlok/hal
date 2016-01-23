class Text < Animatable
  include Processing::Proxy

  attr_reader :text, :options
  
  def initialize(stack, text, x, y, width, height, options={})
    super(stack, x, y, width, height, options)

    options = {resize: true}.merge(options)

    @text = truncate(text, options.delete(:truncate))
    @font_alignment = options.delete(:align)

    @options = options
    @font = stack.vidgenie.load_font(font_path, font_size)

    calculate_text_size
  end

  def identifier
    @text.to_s[0..30] + "..."
  end

  def render
    render_actions do
      context.push_matrix
      context.text_font(@font.pfont)
      context.text_size(adjusted_font_size)

      if stack.transitioning_out? and stack.out_transition.effect.text?
        stack.out_transition.effect.text_apply(font_color)
      else
        if vidgenie.debugging_enabled?
          context.fill(*debug_color)
        else
          context.fill(*font_color)
        end
      end

      context.translate(0,0, -depth) if depth?
      context.text_align(*font_alignment)
      context.text_leading(line_spacing) if line_spacing
      context.text(text, current_x, current_y, depth_adjusted_width, depth_adjusted_height)

      # print_text_information

      if stack.transitioning_out? and stack.out_transition.effect.text?
        stack.out_transition.effect.text_remove
      else
        context.no_fill
      end

      context.pop_matrix
    end
  end

  def print_text_information
    return nil if @printed_info
    puts "#{@text}: #{text_width} x #{text_height}, #{width} x #{height}  A: #{text_descent}, D: #{text_descent}, New Size: #{adjusted_font_size}"
    @printed_info = true
  end

  def calculate_text_size
    context.push_matrix
    context.text_font(@font.pfont)
    context.text_size(font_size)
    context.text_leading(line_spacing) if line_spacing
    text_dimensions
    context.pop_matrix
  end

  def text_dimensions
    [text_width, text_height]
  end

  def text_width
    @text_width ||= context.text_width(@text)
  end

  def text_height
    @text_height ||= text_ascent + text_descent
  end

  def text_ascent
    @text_ascent ||= context.text_ascent
  end

  def text_descent
    @text_descent ||= context.text_descent
  end

  def font_color
    return [0,0,0] unless options[:color]

    options[:color].split(",").map(&:to_i)
  end

  def font_path
    options[:font] || stack.vidgenie.default_font
  end

  def width_fit_percentage
    @width_fit_percentage ||= calculate_fit_percentage(:width)
  end

  def height_fit_percentage
    @height_fit_percentage ||= calculate_fit_percentage(:height)
  end

  def calculate_fit_percentage(dimension)
    return 1 if send(dimension) <= 0 || send("text_#{dimension}") <= 0
    (send(dimension) / send("text_#{dimension}").to_f)
  end

  def fit_percentage
    @fit_percentage ||= width_fit_percentage > height_fit_percentage ? height_fit_percentage : width_fit_percentage
  end

  def font_size
    options[:size] || 32
  end

  def adjusted_font_size
    return font_size if !options[:resize]
    return font_size if fit_percentage >= 1
    (font_size * fit_percentage).to_i - 1
  end

  def font_alignment
    [horizontal_alignment, vertical_alignment]
  end

  def vertical_alignment
    if @font_alignment.present?
      case @font_alignment
      when /baseline/ then BASELINE
      when /bottom/ then BOTTOM
      when /top/ then TOP
      when /center/ then CENTER
      else
        BASELINE
      end
    else
      BASELINE
    end
  end

  def horizontal_alignment
    if @font_alignment.present?
      case @font_alignment
      when /left/ then LEFT
      when /right/ then RIGHT
      when /center/ then CENTER
      else
        LEFT
      end
    else
      LEFT
    end
  end

  def line_spacing
    options[:line_spacing]
  end

  def truncate(text, length)
    return text.to_s if length.to_i == 0 || text.to_s.length <= length.to_i
    "#{text.to_s[0..length-4]}..." ### Remove 4 charachters to the length to make space for the dots..
  end
end