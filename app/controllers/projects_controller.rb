class ProjectsController < ApplicationController
  before_filter :authenticate

  def create
    authorize! :create, Project.new
    @project = Project.new project_params
    if @project.save
      render status: :created, nothing: true, location: project_url(@project)
    else
      render status: 400, nothing: true
    end
  end

  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    if @project.nil?
      render nothing: true, status: :not_found
    end
  end

  private
  def project_params
    params.require(:project).permit(:name)
  end
end
