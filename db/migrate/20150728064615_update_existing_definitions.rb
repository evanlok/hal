class UpdateExistingDefinitions < ActiveRecord::Migration
  def up
    VideoType.reset_column_information
    houztrendz = VideoType.create(name: 'Houztrendz')
    Definition.update_all(video_type_id: houztrendz)
  end

  def down
    houztrendz = VideoType.create(name: 'Houztrendz')
    Definition.where(video_type_id: houztrendz).update_all(video_type_id: nil)
  end
end
