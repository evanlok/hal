class FindTheBestLocationsController < ApplicationController
  def show
    @find_the_best_location = FindTheBestLocation.friendly.find(params[:id])
  end
end
