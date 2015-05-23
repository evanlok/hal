class Admin::BaseController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :authorize_user

  protected

  def authorize_user
    unless current_user.has_role?(:admin)
    redirect_to root_url
    end
  end
end
