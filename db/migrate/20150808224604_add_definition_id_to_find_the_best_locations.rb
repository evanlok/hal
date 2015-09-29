class AddDefinitionIdToFindTheBestLocations < ActiveRecord::Migration
  def up
    add_column :find_the_best_locations, :definition_id, :integer
    add_index :find_the_best_locations, :definition_id
    find_the_home_definition = Definition.find_by(name: 'FindTheHome')
    FindTheBestLocation.update_all(definition_id: find_the_home_definition)
  end

  def down
    remove_index :find_the_best_locations, :definition_id
    remove_column :find_the_best_locations, :definition_id
  end
end
