class TasksController < ApplicationController
  before_filter :authenticate
  before_filter :find, :manager_of_project, :cancelled_or_finished, except: [:create, :index]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    unless find
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
    # unless find
    #   return
    # end
    # unless manager_of_project?
    #   return
    # end
    if [:finished, :cancelled].include? @task.status
      render status: 405, nothing: true
      return
    end
    @task.cancel(current_user)
    render nothing: true, status: 200
  end

  def transferred
    # unless find
    #   return
    # end
    #
    # unless manager_of_project?
    #   return
    # end

    if [:finished, :cancelled].include? @task.status
      render status: 405, nothing: true
      return
    end

    team = Team.find(params[:team_id])
    if team.nil?
      render status: 400, nothing: true
    end
    @task.transfer current_user, team
    render status: 200, nothing: true
  end

  def finished
    @task.finish current_user
    render status: 200, nothing: true
  end

  def assigned
    member = Member.find params[:member_id]
    if member.nil? || current_user.assign != member.assign
      render status: 400, nothing: true
      return
    end

    @task.assign_to current_user, member
    render status: 200, nothing: true
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def manager_of_project
    current_user_project = current_user.assign.try(:assign)
    if current_user_project != @project || !current_user.manager?
      render nothing: true, status: 403
    end
  end

  def cancelled_or_finished
    if [:finished, :cancelled].include? @task.status
      render status: 405, nothing: true
    end
  end

  def find
    @project = Project.find(params[:project_id])
    if @project.nil?
      render nothing: true, status: 404
      return false
    end
    @task = @project.tasks.find(params[:id])
    if @task.nil?
      render nothing: true, status: 404
      return false
    end
    return true
  end

end
