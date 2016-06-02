class Video < ActiveRecord::Base
  # Associations
  belongs_to :videoable, polymorphic: true

  # Validations
  validates :videoable, :resolutions, presence: true

  def base_dir
    "videos/#{id}"
  end

  def url(version=nil)
    return nil unless filename
    version_affix = version ? "_#{version}.mp4" : '.mp4'
    version_filename = filename.gsub(/\..+/, version_affix)
    [ENV['CDN_URL'], base_dir, version_filename].join('/')
  end
end
