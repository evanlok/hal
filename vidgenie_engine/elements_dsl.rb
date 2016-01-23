##
# ElementsDsl is used as a mixing for the Stack and Sequence classes 
# so that they have the ability to define elements within them.
#
#
module ElementsDsl
  
  def custom_shape(x, y, options={}, &block)
    CustomShape.new(self, x, y, options, &block).tap do |custom_shape|
      @elements << custom_shape
    end
  end


  # Create a gradient
  # 
  # @example Draw a custom shape on 0,0 with dimensions 100x100
  #   gradient(0,0,100,100)
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the gradient.
  #
  # @param [ Integer, String ] height The height of the gradient.
  #
  # @param [ Hash ] options
  def gradient(x, y, width, height, options={})
    Gradient.new(self, x, y, width, height, options).tap do |gradient|
      @elements << gradient
    end
  end

  # Create a new context on where to draw things
  # 
  # @example Draw a mask on 0,0 with a size of 100x100
  #   mask(:rect, 0,0, 100,100) do
  #     image("slide.png", 0,0,nil,nil).animate(-600,0, duration: 3)
  #   end
  #
  # @param [ Symbol ] form the shape of the mask. Valid values are: :rect, :ellipse
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the box.
  #
  # @param [ Integer, String ] height The height of the box.
  #
  def mask(form, x, y, width, height, options={}, &block)
    Mask.new(self, form, x, y, width, height, options, &block).tap do |mask|
      @elements << mask
    end
  end

  # Draw a 3D box on the screen
  # 
  # @example A box (x, y, z, width, height, depth)
  #   box(0,0,0, 100,100,100)
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] z The coordinates on the Z axis.
  #
  # @param [ Integer, String ] width The width of the box.
  #
  # @param [ Integer, String ] height The height of the box.
  #
  # @param [ Integer, String ] depth The depth of the box.
  #
  # @param [ Hash ] options
  #
  # @option options [ String ] :color a string with the 3 RGB colors separated by commas. ie: "20,20,20"
  #
  # @option options [ String ] :stroke_color it overrides the color for the stroke.
  #
  # @option options [ Integer ] :stroke_weight width of the stroke in pixels. defaults to 1.
  #
  def box(x, y, z, width, height, depth, options={})
    Box.new(self, x, y, z, width, height, depth, options).tap do |box|
      @elements << box
    end
  end

  # Draw a ellipse on the screen
  # 
  # @example A circle (equal width and height)
  #   rect(0,0,100,100)
  #
  # @example A ellipse
  #   rect(0,0,100,200)
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the ellipse.
  #
  # @param [ Integer, String ] height The height of the ellipse.
  #
  # @param [ Hash ] options
  #
  # @option options [ String ] :color a string with the 3 RGB colors separated by commas. ie: "20,20,20"
  #
  # @option options [ String ] :stroke_color it overrides the color for the stroke.
  #
  # @option options [ Integer ] :stroke_weight width of the stroke in pixels. defaults to 1.
  #
  def ellipse(x, y, width, height, options={})
    Ellipse.new(self, x, y, width, height, options).tap do |ellipse|
      @elements << ellipse
    end
  end

  # Draw a rectangle on the screen
  # 
  # @example A square with square corners
  #   rect(0,0,100,100)
  # @example A square with all corners rounded
  #   rect(0,0,100,100, radius: 10)
  # @example A square with all the top-left and top-right corners rounded
  #   rect(0,0,100,100, radius: "10,5")
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the square.
  #
  # @param [ Integer, String ] height The height of the square.
  #
  # @param [ Hash ] options
  #
  # @option options [ Float, Array ] :radius radius for the rectangle, it supports a single or multiple values
  #
  # @option options [ String ] :color a string with the 3 RGB colors separated by commas. ie: "20,20,20"
  #
  # @option options [ String ] :stroke_color it overrides the color for the stroke.
  #
  # @option options [ Integer ] :stroke_weight width of the stroke in pixels. defaults to 1.
  #
  def rect(x, y, width, height, options={})
    Rectangle.new(self, x, y, width, height, options).tap do |rect|
      @elements << rect
    end
  end

  # Draw a triangle on the screen
  #
  # @example A triangle
  #   triangle(30, 75, 58, 20, 86, 75)
  #
  # @param [ Integer, String ] x1 The x coordinate of first point
  #
  # @param [ Integer, String ] y1 The y coordinate of the first point
  #
  # @param [ Integer, String ] x2 The x coordinate of the second point
  #
  # @param [ Integer, String ] y2 The y coordinate of the second point
  #
  # @param [ Integer, String ] x3 The x coordinate of the third point
  #
  # @param [ Integer, String ] y3 The y coordinate of the thrid point
  #
  def triangle(x1, y1, x2, y2, x3, y3, options={})
    Triangle.new(self, x1, y1, x2, y2, x3, y3, options).tap do |triangle|
      @elements << triangle
    end
  end
  
  # Draws a line (a direct path between two points) to the screen. The version of line() with four parameters draws the line in 2D. To color a line, use the stroke() function. A line cannot be filled, therefore the fill() function will not affect the color of a line. 2D lines are drawn with a width of one pixel by default, but this can be changed with the strokeWeight() function. The version with six parameters allows the line to be placed anywhere within XYZ space. Drawing this shape in 3D with the z parameter requires the P3D parameter in combination with size() as shown in the above example.
  #
  # @example A line 
  #   line(x1, y1, x2, y2)
  #   line(x1, y1, z1, x2, y2, z2)
  #
  # Parameters  
  #
  # x1  float: x-coordinate of the first point
  #
  # y1  float: y-coordinate of the first point
  #
  # x2  float: x-coordinate of the second point
  #
  # y2  float: y-coordinate of the second point
  #
  # z1  float: z-coordinate of the first point
  #
  # z2  float: z-coordinate of the second point


  def line(x1, y1, x2, y2, options={})
    Line.new(self, x1, y1, x2, y2, options).tap do |line|
      @elements << line
    end
  end


  # Group several elements to toghether
  #
  # @example A container for other elements on the screen. The coordinates of the elements
  # inside the overlay will be relative to the overlay.
  #   overlay(0,0,100,100) do
  #     image("1.jpg", 0, 0)
  #   end
  #
  # @note All paramerter passed for dimensions and position accept an Integer or String.
  #
  # An Integer is assumed to be pixels and a String a percentage of the screen size.
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the square.
  #
  # @param [ Integer, String ] height The height of the square.
  #
  # @param [ Proc ] block contains the definitions of the elements inside the overlay
  #
  def overlay(x, y, width, height, options={}, &block)
    Overlay.new(self, x, y, width, height, options, &block).tap do |overlay|
      @elements << overlay
    end
  end

  # Play a video on screen
  #
  # @example Play a full screen video
  #   movie("data/movie.mp4")
  #
  # @example Play a small video somewhere in the middle of the screen
  #   movie("data/movie.mp4", 160, 90, "50%", "50%")
  #
  # @param [ String ] path The full path to the movie location.
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the movie.
  #
  # @param [ Integer, String ] height The height of the movie.
  #
  # @param [ Hash ] options
  #
  # @option options [ Float ] :volume Volume of the movie audio between 0 and 1
  # 0 meaning the sound is muted and 1 full volume.
  #
  def movie(path, x=nil, y=nil, width=nil, height=nil, options={})
    VideoPlayer.new(self, path, x, y, width, height, options).tap do |movie|
      @elements << movie
    end
  end

  # Display an image on screen
  #
  # @example Display an image in the top left corner taking 90% of the screen
  #   image("data/house.jpg", 0, 0, "90%", "90%")
  #
  # @note The width and/or height can be ommitted by just passing a nil value
  # and it will use the provided width/height to calculate the corresponding
  # value keeping the image proportions
  #
  # @param [ String ] path The full path to the image location.
  #
  # @param [ Integer, String ] x The coordinates on the X axis.
  #
  # @param [ Integer, String ] y The coordinates on the Y axis.
  #
  # @param [ Integer, String ] width The width of the image.
  #
  # @param [ Integer, String ] height The height of the image.
  #
  # @param [ Hash ] options
  #
  # @option options [ Integer ] :blur Executes a gaussian blur with the value as the radius
  #
  def image(path, x, y, width=nil, height=nil, options={})
    ImagePlayer.new(self, path, x, y, width, height, options).tap do |image|
      @elements << image
    end
  end

  # Play an audio file
  #
  # @example Play an audio file
  #   audio("data/house.wav")
  #
  # @param [ String ] path The full path to the audio file location.
  #
  # @param [ Hash ] options
  #
  # @option options [ Integer ] :volume Volume of the audio in decibels
  #
  def audio(path, options={})
    AudioPlayer.new(self, path, options).tap do |audio|
      @elements << audio
    end
  end

  # Wrap elements so that they are played sequencially and not at the same
  # time.
  #
  # @example Display multiple audio files one after another
  #   sequence do
  #     audio("data/bed.wav")
  #     audio("data/and.wav")
  #     audio("data/bath.wav")
  #   end
  #
  # @param [ Proc ] block The body of the sequence.
  #
  def sequence(&block)
    Sequence.new(self, &block).tap do |sequence|
      @elements << sequence
    end
  end

  # Showcase a series of photos in the screen
  # 
  # @example Display a slideshow with the images animating from right to left
  #   slideshow(["bath.jpg", "bed.jpg", "kitchen.jpg"], "100", "50", nil, "80", delay: 2) do |image|
  #     image.animate("50", "50", duration: 2, easing: "linear", rotate: 0)
  #           .animate("-100", "50", duration: 2, easing: "linear", rotate: 0..-2)
  #   end
  #
  # @note The animations in the block are applied to every single image
  #
  # @param [ Array<String> ] paths Array of string with the fullpath to the images
  #
  # @param [ Integer, String ] x The starting X coordinates of every image.
  #
  # @param [ Integer, String ] y The starting Y coordinates of every image.
  #
  # @param [ Integer, String ] width The width of every image.
  #
  # @param [ Integer, String ] height The height of every image.
  #
  # @param [ Hash ] options
  # 
  # @option options [ Integer ] :delay Number of seconds between images
  #
  # @option options [ String ] :origin The value of origin for images. ie: "center"
  #
  # @option options [ String ] :x_origin The value of x_origin for images. ie: "center"
  #
  # @option options [ String ] :y_origin The value of y_origin for images. ie: "center"
  #
  def slideshow(paths, x, y, width, height, options={}, &block)
    Slideshow.new(self, paths, x, y, width, height, options, &block).tap do |slideshow|
      @elements << slideshow
    end
  end

  # Display text on screen
  #
  # @example Display a text of "Hi"
  #   text("Hi", 0, 0, {font: "BebasNeue", size: 24, color: "#ffffff"})
  #
  # @param [ String ] string the text to be displayed
  #
  # @param [ Integer, String ] x the starting X coordinates of the text
  #
  # @param [ Integer, String ] y the starting Y coordinates of the text
  #
  # @param [ Hash ] options
  #
  # @option options [ String ] :font name of the font
  #
  # @option options [ Integer ] :size size in pixels of the text
  #
  # @option options [ String ] :color a string with the 3 RGB colors separated by commas. ie: "20,20,20"
  #
  # @option options [ String ] :align one of the following three options: "left", "center", "right"
  #
  # @option options [ Integer ] :line_spacing line spacing size in pixels
  #
  def text(string, x, y, width, height, options={})
    Text.new(self, string, x, y, width, height, options).tap do |text|
      @elements << text
    end
  end

  # Display a animated counter
  #
  # @example Display a counter of up to 10
  #   counter(10, 0, 0, {font: "BebasNeue", size: 24, color: "#ffffff"})
  #
  # @param [ Integer ] number to be counted to
  #
  # @param [ Integer, String ] x the starting X coordinates of the counter
  #
  # @param [ Integer, String ] y the starting Y coordinates of the counter
  #
  # @param [ Hash ] options
  #
  # @option options [ String ] :font name of the font
  #
  # @option options [ Integer ] :size size in pixels of the text
  #
  # @option options [ String ] :color a string with the 3 RGB colors separated by commas. ie: "20,20,20"
  #
  # @option options [ String ] :align one of the following three options: "left", "center", "right"
  #
  # @option options [ Integer ] :line_spacing line spacing size in pixels
  #
  # @option options [ Integer ] :duration seconds it will take to count up to the number
  #
  def counter(number, x, y, width, height, options={})
    Counter.new(self, number, x, y, width, height, options).tap do |counter|
      @elements << counter
    end
  end

  def inner_stack(options={}, &block)
    InnerStack.new(self, options, &block).tap do |stack|
      @elements << stack
    end
  end
end
