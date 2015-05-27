class Video < ActiveRecord::Base
  # Associations
  belongs_to :videoable, polymorphic: true
  belongs_to :definition

  # Validations
  validates :videoable, presence: true
  validates :definition, presence: true, on: :create

  def base_dir
    "videos/#{id}"
  end

  def url(version=nil)
    return nil unless filename

    version_affix = case version.to_s
                       when '240'
                         '_240.mp4'
                       when '720'
                         '_720.mp4'
                       else
                         '.mp4'
                     end

    version_filename = filename.gsub(/\..+/, version_affix)
    [ENV['CDN_URL'], base_dir, version_filename].join('/')
  end
end
