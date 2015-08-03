require 'rails_helper'

RSpec.describe Admin::VideoContentsController do
  login_admin
  let(:video_content) { create(:video_content) }

  describe 'GET index' do
    it 'renders page' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET new' do
    it 'renders page' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'GET show' do
    it 'renders page' do
      get :show, id: video_content
      expect(response).to be_success
    end

    context 'with a video' do
      let!(:video) { create(:video, videoable: video_content) }

      it 'sets video and renders page' do
        get :show, id: video_content
        expect(assigns(:video)).to be_present
        expect(response).to be_success
      end
    end
  end

  describe 'POST create' do
    let(:definition) { create(:definition) }

    it 'creates new video type' do
      post :create, video_content: attributes_for(:video_content).merge!(definition_id: definition.id)
      expect(assigns(:video_content)).to be_persisted
      expect(response).to redirect_to(admin_video_content_url(assigns(:video_content)))
    end
  end

  describe 'GET edit' do
    it 'renders page' do
      get :edit, id: video_content
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates video content' do
      patch :update, id: video_content, video_content: { data: '{"attr1": 100}' }
      video_content.reload
      expect(video_content.data).to eq({ attr1: 100 }.stringify_keys)
      expect(response).to redirect_to(admin_video_content_url(assigns(:video_content)))
    end
  end

  describe 'DELETE destroy' do
    it 'deletes video content' do
      delete :destroy, id: video_content
      expect(VideoContent.where(id: video_content)).to_not exist
      expect(response).to redirect_to(admin_video_contents_url)
    end
  end
end
