json.extract! scene, :id, :name, :active, :width, :height, :duration, :created_at, :updated_at

json.attributes do
  json.array! scene.scene_attributes do |scene_attribute|
    json.extract! scene_attribute, :name, :display_name, :position, :description
    json.type scene_attribute.scene_attribute_type.name
  end
end
