json.extract! scene, :id, :name, :active, :width, :height, :duration, :created_at, :updated_at

json.attributes do
  json.array! scene.scene_attributes do |scene_attribute|
    json.extract! scene_attribute, :name, :display_name, :position, :description
    json.type scene_attribute.scene_attribute_type.name
  end
end

json.global_attributes do
  json.array! scene.global_scene_attributes do |global_scene_attribute|
    json.extract! global_scene_attribute, :name, :display_name, :description
    json.type global_scene_attribute.scene_attribute_type.name
  end
end
