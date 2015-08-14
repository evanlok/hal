class Admin::CoreLogicLocationsController < Admin::BaseController
  before_action :core_logic_location, only: [:show, :edit, :update, :destroy]

  def index
    @core_logic_locations = CoreLogicLocation.order(updated_at: :desc).page(params[:page])
  end

  def show
    @video = @core_logic_location.video
  end

  def new
    @core_logic_location = CoreLogicLocation.new
  end

  def create
    @core_logic_location = CoreLogicLocation.new(core_logic_location_params)

    if @core_logic_location.save
      redirect_to admin_core_logic_location_url(@core_logic_location), notice: "Created location: #{@core_logic_location.county}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @core_logic_location.update_attributes(core_logic_location_params)
      redirect_to admin_core_logic_location_url(@core_logic_location), notice: "Updated location: #{@core_logic_location.county}"
    else
      render :edit
    end
  end

  def destroy
    @core_logic_location.destroy
    redirect_to admin_core_logic_locations_url, notice: "Deleted location: #{@core_logic_location.county}"
  end

  def import
    file = params[:csv][:file]
    Importers::FindTheBestLocationCSVImporter.new(file.path).import
    redirect_to admin_core_logic_locations_url, notice: 'Import successful!'
  end

  protected

  def core_logic_location
    @core_logic_location = FindTheBestLocation.friendly.find(params[:id])
  end

  def core_logic_location_params
    params.require(:core_logic_location).permit!
  end
end
