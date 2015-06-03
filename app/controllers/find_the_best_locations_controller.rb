class FindTheBestLocationsController < ApplicationController
  before_action :load_find_the_best_location, except: :fth_embed
  after_action :allow_iframe

  def show
  end

  def embed
    render layout: 'embed'
  end

  def fth_embed
    @find_the_best_location = FindTheBestLocation.find_by(ftb_id: params[:ftb_id])
    raise ActiveRecord::RecordNotFound.new("Couldn't find FindTheBestLocation with 'ftb_id'=#{params[:ftb_id]}") unless @find_the_best_location
    @video = @find_the_best_location.try(:video)
    render :embed, layout: 'embed'
  end

  protected

  def load_find_the_best_location
    @find_the_best_location = FindTheBestLocation.friendly.find(params[:id])
    @video = @find_the_best_location.try(:video)
  end

  def allow_iframe
    response.headers.except!('X-Frame-Options')
  end
end
