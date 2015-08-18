class FindTheBestLocationsController < ApplicationController
  before_action :load_core_logic_location, except: :fth_embed
  after_action :allow_iframe

  def show
  end

  def embed
    render layout: 'embed'
  end

  def fth_embed
    @core_logic_location = CoreLogicLocation.find_by(zip_code: params[:zip_code], period_date: params[:period_date])
    raise ActiveRecord::RecordNotFound.new("Couldn't find CoreLogicLocation with 'zip_code'=#{params[:zip_code]} and 'period_date'=#{params[:period_date]}") unless @core_logic_location
    @video = @core_logic_location.try(:video)
    render :embed, layout: 'embed'
  end

  protected

  def load_find_the_best_location
    @core_logic_location = CoreLogicLocation.friendly.find(params[:id])
    @video = @core_logic_location.try(:video)
  end

  def allow_iframe
    response.headers.except!('X-Frame-Options')
  end
end
