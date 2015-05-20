class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.string :name
      t.string :class_name
      t.boolean :active, default: false
      t.text :vgl_header
      t.text :vgl_content
      t.text :vgl_methods
      t.timestamps null: false
    end
  end
end
