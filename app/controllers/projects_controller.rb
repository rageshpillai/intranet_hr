class ProjectsController < ApplicationController
    
  load_and_authorize_resource 
  skip_load_and_authorize_resource :only => :create
  before_action :authenticate_user!
  before_action :load_project, except: [:index, :new, :create]

  include RestfulAction
  
  def index
    @projects = Project.get_all_sorted_by_name
    respond_to do |format|
      format.html
      format.csv { send_data @projects.to_csv }
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(safe_params)
    if @project.save  
      flash[:success] = "Project created Succesfully"
      redirect_to projects_path
    else
      render 'new'
    end
  end
  
  def update
    @project.user_ids = [] if params[:user_ids].blank? and params['tech_details'].nil?
    update_obj(@project, safe_params, projects_path)
  end

  def show
    @users = @project.users
  end
  
  def destroy
    if @project.destroy
     flash[:notice] = "Project deleted Succesfully" 
    else
     flash[:notice] = "Error in deleting project"
    end
     redirect_to projects_path
  end

  private
  def safe_params
    params.require(:project).permit(:name, :start_date, :end_date, :managed_by, :code_climate_id, :code_climate_snippet, :code_climate_coverage_snippet, :is_active, :ruby_version, :rails_version, :database, :database_version, :deployment_server, :deployment_script, :web_server, :app_server, :payment_gateway, :image_store, :index_server, :background_jobs, :sms_gateway, :other_frameworks, :other_details, :user_ids => [])

  end

  def load_project
    @project = Project.find(params[:id])
  end
end
