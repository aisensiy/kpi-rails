class ProjectsController < ApplicationController
  respond_to :json
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

  def assigned
    authorize! :assigned, Team.new
    @project = Project.find(params[:id])
    team = Team.find(params[:team_id])
    if team.nil? || @project.nil?
      render status: 404, nothing: true
    else
      team.assign_to @project
      render status: 200, nothing: true
    end
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
