class Admin::FindTheBestLocationsController < Admin::BaseController
  before_action :load_find_the_best_location, only: [:show, :edit, :update, :destroy]

  def index
    @find_the_best_locations = FindTheBestLocation.order(updated_at: :desc).page(params[:page])
  end

  def show
    @video = @find_the_best_location.video
  end

  def new
    @find_the_best_location = FindTheBestLocation.new
  end

  def create
    @find_the_best_location = FindTheBestLocation.new(find_the_best_location_params)

    if @find_the_best_location.save
      redirect_to admin_find_the_best_location_url(@find_the_best_location), notice: "Created location: #{@find_the_best_location.county}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @find_the_best_location.update_attributes(find_the_best_location_params)
      redirect_to admin_find_the_best_location_url(@find_the_best_location), notice: "Updated location: #{@find_the_best_location.county}"
    else
      render :edit
    end
  end

  def destroy
    @find_the_best_location.destroy
    redirect_to admin_find_the_best_locations_url, notice: "Deleted location: #{@find_the_best_location.county}"
  end

  def import
    file = params[:csv][:file]
    Importers::FindTheBestLocationCSVImporter.new(file.path).import
    redirect_to admin_find_the_best_locations_url, notice: 'Import successful!'
  end

  protected

  def load_find_the_best_location
    @find_the_best_location = FindTheBestLocation.friendly.find(params[:id])
  end

  def find_the_best_location_params
    params.require(:find_the_best_location).permit!
  end
end
