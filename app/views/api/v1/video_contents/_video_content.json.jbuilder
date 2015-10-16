json.extract! video_content, :id, :uid, :callback_url
json.definition video_content.definition.class_name
json.video_type video_content.definition.video_type.name
