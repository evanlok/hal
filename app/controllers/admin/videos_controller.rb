class Admin::VideosController < Admin::BaseController
  before_action :find_videoable

  def create
    VideoGenerator.new(@videoable).generate
    redirect_to [:admin, @videoable], notice: "Generated video with definition: #{@videoable.definition.name}"
  end

  def create_preview
    VideoGenerator.new(@videoable).generate(stream_only: true)
    # TODO: redirect to preview page
    redirect_to [:admin, @videoable], notice: "Generated preview video with definition: #{@videoable.definition.name}"
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
