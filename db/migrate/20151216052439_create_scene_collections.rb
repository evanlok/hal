class CreateSceneCollections < ActiveRecord::Migration
  def change
    create_table :scene_collections do |t|
      t.text :font
      t.text :music
      t.text :color
      t.text :callback_url

      t.timestamps null: false
    end
  end
end
