class AddBackgroundToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :background, :string
  end
end
