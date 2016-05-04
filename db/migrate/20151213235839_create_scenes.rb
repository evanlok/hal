class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.string :name
      t.boolean :active, default: false
      t.text :vgl_content

      t.timestamps null: false
    end
  end
end
