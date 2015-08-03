class RemoveDefinitionIdFromVideos < ActiveRecord::Migration
  def change
    remove_index :videos, :definition_id
    remove_column :videos, :definition_id
  end
end
