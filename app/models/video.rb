class Video < ActiveRecord::Base
  # Associations
  belongs_to :videoable, polymorphic: true

  # Validations
  validates :videoable, :resolutions, presence: true

  # Callbacks
  after_destroy :remove_s3_files

  def base_dir
    "videos/#{id}"
  end

  def path(version = nil)
    return nil unless filename
    version_affix = version ? "_#{version}.mp4" : '.mp4'
    version_filename = filename.gsub(/\..+/, version_affix)
    [base_dir, version_filename].join('/')
  end

  def url(version=nil)
    return nil unless filename
    [ENV['CDN_URL'], path(version)].join('/')
  end

  private

  def remove_s3_files
    objects = resolutions.map do |_name, (_width, height)|
      { key: path(height) }
    end

    s3 = Aws::S3::Client.new
    s3.delete_objects(
      bucket: ENV['S3_BUCKET'],
      delete: {
        objects: objects
      }
    )
  end
end
