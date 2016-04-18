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
      expect_any_instance_of(VideoContent).to receive(:generate) { true }
      post :create, video_content_attributes.merge(format: :json)
      expect(response).to have_http_status(201)
    end

    context 'with invalid params' do
      it 'returns error' do
        post :create, video_content_attributes.merge(format: :json, data: nil)
        expect(response).to have_http_status(400)
      end
    end

    context 'with an existing VideoContent record' do
      let!(:video_content) { create(:video_content) }

      it 'updates existing record' do
        expect_any_instance_of(VideoContent).to receive(:generate) { true }
        expect {
          post :create,
               uid: video_content.uid,
               definition: video_content.definition.class_name,
               video_type: video_content.definition.video_type.name,
               data: { key: 'new' }.to_json,
               format: :json
        }.to_not change(VideoContent, :count)
        expect(response).to be_success
        expect(video_content.reload.data).to eq({ key: 'new' }.stringify_keys)
      end
    end
  end

  describe 'GET show' do
    let(:video_content) { create(:video_content) }
    let!(:video) { create(:video, videoable: video_content) }

    it 'renders video json' do
      get :show, id: video_content, format: :json
      expect(response).to be_success
    end
  end
end
