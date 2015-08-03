class AddVideoTypeIdToDefinitions < ActiveRecord::Migration
  def change
    add_column :definitions, :video_type_id, :integer
    add_index :definitions, :video_type_id
  end
end
