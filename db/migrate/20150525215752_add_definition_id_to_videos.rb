class AddDefinitionIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :definition_id, :integer
    add_index :videos, :definition_id
  end
end
