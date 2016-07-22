class SceneAttribute < ActiveRecord::Base
  acts_as_list scope: :scene_id

  # Associations
  belongs_to :scene_attribute_type
  belongs_to :scene, touch: true

  # Validations
  validates :scene_attribute_type, :scene, :name, :display_name, presence: true
  validates :name, format: { with: /\A[a-z_\d]+\z/, message: 'only allows lowercase letters, underscores, and numbers' }
  validates :name, uniqueness: { scope: :scene_id }

  # Callbacks
  before_save :cast_display_config_values

  private

  def cast_display_config_values
    display_config.reject! { |_k, v| v.blank? }

    display_config.transform_values! do |value|
      if value =~ /\A-?\d+(\.\d+)?\z/
        value =~ /\./ ? value.to_f : value.to_i
      else
        value
      end
    end
  end
end
