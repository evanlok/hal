class Admin::VideoContentsController < Admin::BaseController
  before_action :load_video_content, only: [:show, :edit, :update, :destroy]

  def index
    @video_contents = VideoContent.includes(definition: :video_type).order(id: :desc).page(params[:page])
  end

  def new
    @video_content = VideoContent.new
  end

  def create
    @video_content = VideoContent.new(video_content_params)

    if @video_content.save
      redirect_to admin_video_content_url(@video_content), notice: "Created Video Content: #{@video_content.uid}"
    else
      render :new
    end
  end

  def show
    @video = @video_content.video
  end

  def edit
  end

  def update
    if @video_content.update_attributes(video_content_params)
      redirect_to admin_video_content_url(@video_content), notice: "Updated Video Content: #{@video_content.uid}"
    else
      render :edit
    end
  end

  def destroy
    @video_content.destroy
    redirect_to admin_video_contents_url, notice: "Deleted Video Content: #{@video_content.uid}"
  end

  protected

  def video_content_params
    params.require(:video_content).permit!
  end

  def load_video_content
    @video_content = VideoContent.find(params[:id])
  end
end
