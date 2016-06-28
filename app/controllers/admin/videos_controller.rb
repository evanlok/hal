class Admin::VideosController < Admin::BaseController
  before_action :find_videoable, except: [:index]

  def index
    @videos = Video.order(id: :desc).page(params[:page]).per(50)
  end

  def create
    @videoable.generate
    redirect_to [:admin, @videoable], notice: "Generated video with definition: #{@videoable.definition.name}"
  end

  def create_preview
    video_preview = @videoable.preview

    if video_preview
      redirect_to video_preview, notice: "Generated preview video with definition: #{@videoable.definition.name}"
    else
      render text: @videoable.errors.full_messages.join("\n")
    end
  end

  protected

  def find_videoable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @videoable = $1.classify.constantize.find(value)
        return @videoable
      end
    end
  end
end
