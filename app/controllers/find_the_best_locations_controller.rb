class FindTheBestLocationsController < ApplicationController
  before_action :load_find_the_best_location

  def show
  end

  def embed
    render layout: 'embed'
  end

  protected

  def load_find_the_best_location
    @find_the_best_location = FindTheBestLocation.friendly.find(params[:id])
    @video = @find_the_best_location.try(:video)
  end
end
