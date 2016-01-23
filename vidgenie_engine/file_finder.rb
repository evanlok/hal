class FileFinder
  
  attr_reader :path, :data_folder_path

  def initialize(path, data_folder_path=ENV['DATA_FOLDER'])
    @path = path.to_s.gsub(/\A\//, "")
    @data_folder_path = data_folder_path.to_s.gsub(/\/\Z/, "")
  end

  def location
    [data_folder_path, path].join("/")
  end
end