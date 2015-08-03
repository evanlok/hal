class Admin::VideoTypesController < Admin::BaseController
  before_action :load_video_type, only: [:edit, :update, :destroy]
  
  def index
    @video_types = VideoType.order(:name).page(params[:page])
  end

  def new
    @video_type = VideoType.new
  end

  def create
    @video_type = VideoType.new(video_type_params)

    if @video_type.save
      redirect_to admin_video_types_url, notice: "Created Video Type: #{@video_type.name}"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @video_type.update_attributes(video_type_params)
      redirect_to admin_video_types_url, notice: "Updated Video Type: #{@video_type.name}"
    else
      render :edit
    end
  end

  def destroy
    @video_type.destroy
    redirect_to admin_video_types_url, notice: "Deleted Video Type: #{@video_type.name}"
  end

  protected

  def video_type_params
    params.require(:video_type).permit!
  end

  def load_video_type
    @video_type = VideoType.find(params[:id])
  end
end
