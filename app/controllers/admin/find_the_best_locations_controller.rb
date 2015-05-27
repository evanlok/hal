class Admin::FindTheBestLocationsController < Admin::BaseController
  before_action :load_find_the_best_location, only: [:edit, :update, :destroy]

  def index
    @find_the_best_locations = FindTheBestLocation.order(updated_at: :desc).page(params[:page])
  end

  def new
    @find_the_best_location = FindTheBestLocation.new
  end

  def create
    @find_the_best_location = FindTheBestLocation.new(find_the_best_location_params)

    if @find_the_best_location.save
      redirect_to admin_find_the_best_locations_url, notice: "Created location: #{@find_the_best_location.county}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @find_the_best_location.update_attributes(find_the_best_location_params)
      redirect_to admin_find_the_best_locations_url, notice: "Updated location: #{@find_the_best_location.county}"
    else
      render :edit
    end
  end

  def destroy
    @find_the_best_location.destroy
    redirect_to admin_find_the_best_locations_url, notice: "Deleted location: #{@find_the_best_location.county}"
  end

  protected

  def load_find_the_best_location
    @find_the_best_location = FindTheBestLocation.find(params[:id])
  end

  def find_the_best_location_params
    params.require(:find_the_best_location).permit!
  end
end
