class Video < ActiveRecord::Base
  # Associations
  belongs_to :videoable, polymorphic: true
  belongs_to :definition

  # Validations
  validates :videoable, presence: true
  validates :definition, presence: true, on: :create

  def base_dir
    "houztrendz/videos/#{id}"
  end

  def url
    [ENV['CDN_URL'], base_dir, filename].join('/')
  end
end
