require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  before(:each) do
    @project = create :projectOne
    @team = create :teamOne
    @manager = create :manager
    @employee = create :employee

    @employee.assign_to @team
    @manager.assign_to @team
    @team.assign_to @project
  end

  after(:each) do
    logout
  end

  describe "create task" do
    it "should create new task by manger in team" do
      login @manager
      task = attributes_for :task
      post "/projects/#{@project.id}/tasks", task: task
      expect(response).to have_http_status 201
      @project.reload
      task = @project.tasks.first
      expect(response.headers["Location"]).to end_with(project_task_url(@project, task))
    end

    it "should 403 if current member is not manage of the team assign to the project" do
      othermanger = create :manager, name: 'manage2'
      task = attributes_for :task
      login othermanger
      post "/projects/#{@project.id}/tasks", task: task
      expect(response).to have_http_status 403
    end
  end
end
