class AddDisplayConfigToSceneAttributes < ActiveRecord::Migration
  def change
    add_column :scene_attributes, :display_config, :jsonb, default: {}
  end
end
