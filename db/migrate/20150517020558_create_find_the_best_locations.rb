class CreateFindTheBestLocations < ActiveRecord::Migration
  def up
    create_table :find_the_best_locations do |t|
      t.integer :ftb_id
      t.string :county
      t.text :sale_price_intro
      t.text :sale_price_verb
      t.text :sale_price_change
      t.text :sale_price_end
      t.text :expected_intro
      t.text :expected_change
      t.text :expected_months
      t.text :list_price_intro
      t.text :list_price_change
      t.text :list_price_end
      t.text :market_text
      t.timestamps null: false
    end

    add_index :find_the_best_locations, :ftb_id
  end

  def down
    drop_table :find_the_best_locations
  end
end
