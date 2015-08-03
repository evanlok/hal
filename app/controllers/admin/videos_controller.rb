class Admin::VideosController < Admin::BaseController
  def create
    @videoable = find_videoable
    VideoGenerator.new(@videoable).generate
    redirect_to [:admin, @videoable], notice: "Generated video with definition: #{@videoable.definition.name}"
  end

  protected

  def find_videoable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end
