class Admin::CsvImportsController < Admin::BaseController
  def index
  end

  def core_logic
    file = params[:csv][:file]
    Importers::CoreLogicLocationCSVImporter.new(file.path).import
    redirect_to admin_csv_imports_url, notice: 'CoreLogic locations import successful!'
  end
end
