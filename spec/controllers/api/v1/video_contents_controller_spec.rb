require 'rails_helper'

RSpec.describe Api::V1::VideoContentsController do
  describe 'POST create' do
    let(:video_type) { create(:video_type) }
    let(:definition) { create(:definition, video_type: video_type) }
    let(:video_content_attributes) do
      {
        video_type: video_type.name,
        definition: definition.class_name,
        data: { key: 'val' }.to_json,
        uid: 'uid',
        callback_url: 'callback_url'
      }
    end

    it 'creates video content record and generates video' do
      expect_any_instance_of(VideoGenerator).to receive(:generate)
      post :create, video_content_attributes.merge(format: :json)
      expect(response).to have_http_status(201)
    end

    context 'with invalid params' do
      it 'returns error' do
        post :create, video_content_attributes.merge(format: :json, data: nil)
        expect(response).to have_http_status(400)
      end
    end
  end
end
