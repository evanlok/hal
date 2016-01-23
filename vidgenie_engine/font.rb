class Font
  
  attr_reader :path, :size, :pfont, :vidgenie

  def initialize(vidgenie, path, size=64)
    @path = path
    @size = size
    @vidgenie = vidgenie

    finder = FileFinder.new(@path)

    @pfont = vidgenie.app.create_font(finder.location, size)
  end
end