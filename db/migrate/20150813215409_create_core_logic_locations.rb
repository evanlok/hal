class CreateCoreLogicLocations < ActiveRecord::Migration
  def change
    create_table :core_logic_locations do |t|
      t.integer :zip_code
      t.string :tier_name
      t.string :metirc
      t.float :active_list_price_mean
      t.float :active_list_price_median
      t.integer :active_listings_dom_mean
      t.integer :active_listings_dom_median
      t.integer :active_listings_inventory_count
      t.integer :sold_inventory_count
      t.integer :sold_list_price_mean
      t.integer :sold_listings_dom_mean
      t.integer :definition_id
      t.string :slug
      t.timestamps null: false
    end
    add_index "core_logic_locations", ["slug"], name: "index_core_logic_locations_on_slug", unique: true, using: :btree
    add_index "core_logic_locations", ["definition_id"], name: "index_core_logic_locations_on_definition_id", using: :btree
  end
end
