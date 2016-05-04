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
    @videoable.preview
    redirect_to [@videoable.video, {autoplay: 1}], notice: "Generated preview video with definition: #{@videoable.definition.name}"
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
