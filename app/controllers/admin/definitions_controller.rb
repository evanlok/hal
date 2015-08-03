class Admin::DefinitionsController < Admin::BaseController
  before_action :load_definition, except: [:index, :new, :create]

  def index
    @definitions = Definition.includes(:video_type).order('video_types.name, definitions.name').page(params[:page])
  end

  def new
    @definition = Definition.new
    js :edit
  end

  def create
    @definition = Definition.new(definition_params)

    if @definition.save
      redirect_to admin_definitions_url, notice: "Created definition: #{@definition.name}"
    else
      js :edit
      render :new
    end
  end

  def edit
  end

  def update
    if @definition.update_attributes(definition_params)
      redirect_to admin_definitions_url, notice: "Updated definition: #{@definition.name}"
    else
      js :edit
      render :edit
    end
  end

  def destroy
    @definition.destroy
    redirect_to admin_definitions_url, notice: "Deleted definition: #{@definition.name}"
  end

  protected

  def load_definition
    @definition = Definition.find(params[:id])
  end

  def definition_params
    params.require(:definition).permit!
  end
end
