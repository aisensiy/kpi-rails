class TasksController < ApplicationController
  before_filter :authenticate

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @project = Project.find(params[:project_id])
    if @project.nil?
      render nothing: true, status: 404
      return
    end
    @task = @project.tasks.find(params[:id])
    if @task.nil?
      render nothing: true, status: 404
      return
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build(task_params)
    current_user_project = current_user.assign.try(:assign)
    if current_user_project != @project || !current_user.manager?
      render nothing: true, status: 403
      return
    end

    @task.team_id = current_user.assign.id
    @task.member_id = current_user.id

    if @task.save
      render nothing: true, status: :created, location: project_task_url(@project, @task)
    else
      render nothing: true, status: 400
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description)
    end
end
