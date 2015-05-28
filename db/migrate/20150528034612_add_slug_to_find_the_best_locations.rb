class AddSlugToFindTheBestLocations < ActiveRecord::Migration
  def change
    add_column :find_the_best_locations, :slug, :string
    add_index :find_the_best_locations, :slug, unique: true
  end
end
