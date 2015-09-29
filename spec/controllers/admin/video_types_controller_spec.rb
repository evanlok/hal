require 'rails_helper'

RSpec.describe Admin::VideoTypesController do
  login_admin
  let(:video_type) { create(:video_type) }

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

  describe 'POST create' do
    it 'creates new video type' do
      post :create, video_type: attributes_for(:video_type)
      expect(assigns(:video_type)).to be_persisted
      expect(response).to redirect_to(admin_video_types_url)
    end
  end

  describe 'GET edit' do
    it 'renders page' do
      get :edit, id: video_type
      expect(response).to be_success
    end
  end

  describe 'PATCH update' do
    it 'updates video type' do
      patch :update, id: video_type, video_type: { description: 'New Description'}
      video_type.reload
      expect(video_type.description).to eq('New Description')
      expect(response).to redirect_to(admin_video_types_url)
    end
  end

  describe 'DELETE destroy' do
    it 'deletes video type' do
      delete :destroy, id: video_type
      expect(VideoType.where(id: video_type)).to_not exist
      expect(response).to redirect_to(admin_video_types_url)
    end
  end
end
