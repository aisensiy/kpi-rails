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

  describe "get one task" do
    it 'should get one task including events' do
      login @manager
      task = @project.tasks.create(
          name: 'abc',
          description: 'bbc',
          team_id: @manager.assign.id,
          member_id: @manager.id)

      get "/projects/#{@project.id}/tasks/#{task.id}"
      expect(response).to have_http_status 200
      data = JSON.parse(response.body)
      expect(data["name"]).to eq(task.name)
      expect(data["events"].size).to eq(1)
      team2 = create :teamTwo
      task.transfer(@manager, team2)

      get "/projects/#{@project.id}/tasks/#{task.id}"
      data = JSON.parse(response.body)
      expect(data["events"].size).to eq(2)
    end

    it "should 404 if no such task" do
      login @manager
      get "/projects/#{@project.id}/tasks/123"
      expect(response).to have_http_status 404
    end
  end

  describe "should cancel task" do
    before :each do
      @task = @project.tasks.create(
          name: 'abc',
          description: 'bbc',
          team_id: @manager.assign.id,
          member_id: @manager.id)
    end

    it "should cancel task" do
      login @manager
      delete "/projects/#{@project.id}/tasks/#{@task.id}"
      expect(response).to have_http_status 200
    end

    it "should 403 if not manger of the team" do
      login @employee
      delete "/projects/#{@project.id}/tasks/#{@task.id}"
      expect(response).to have_http_status 403
    end

    it "should 404 if project or task not found" do
      login @employee
      delete "/projects/#{@project.id}/tasks/213"
      expect(response).to have_http_status 404
    end
  end

  describe "transfer task to other team" do
    before :each do
      @task = @project.tasks.create(
          name: 'abc',
          description: 'bbc',
          team_id: @manager.assign.id,
          member_id: @manager.id)
    end

    it "should transfer success" do
      login @manager
      team2 = create :teamTwo
      post "/projects/#{@project.id}/tasks/#{@task.id}/transferred", team_id: team2.id.to_s
      expect(response).to have_http_status 200
    end
  end
end
