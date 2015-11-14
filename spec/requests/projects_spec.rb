require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "create project" do
    it 'should create project with admin login' do
      admin = create(:admin)
      login(admin)
      project = attributes_for :projectOne
      post "/projects", project: project
      expect(response).to have_http_status(:created)
      project = Project.first
      expect(response.headers["Location"]).to end_with project_url(project)
    end

    it "should get 400 with bad request" do
      admin = create(:admin)
      login(admin)
      post "/projects", project: {other: 123}
      expect(response).to have_http_status(400)
    end

    it 'should forbidden without admin login' do
      employee = create(:employee)
      login(employee)
      project = attributes_for :projectOne
      post "/projects", project: project
      expect(response).to have_http_status(403)
    end
  end

  describe "get one project" do
    it "should get one project" do
      project = create :projectOne
      employee = create :employee
      login(employee)
      get "/projects/#{project.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["name"]).to eq(project.name)
    end

    it 'should 404 with project not found' do
      employee = create :employee
      login(employee)
      get "/projects/1"
      expect(response).to have_http_status(404)
    end
  end

  describe "list projects" do
    it 'should get a list of projects' do
      project = create :projectOne
      5.times do |i|
        create :projectOne, name: "project_#{i}"
      end

      employee = create :employee
      login(employee)

      get "/projects"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[0]
      expect(first["url"]).to end_with("/projects/#{project.id}")
    end
  end

  describe "assign project to team" do
    it "should assign project to a team by admin" do
      team = create :teamOne
      project = create :projectOne
      admin = create :admin
      login admin

      post "/projects/#{project.id}/assigned", team_id: team.id
      expect(response).to have_http_status 200
      expect(team.assign).to eq(project)
    end

    it "should 403 if not a admin" do
      team = create :teamOne
      project = create :projectOne
      employee = create :employee
      login employee

      post "/projects/#{project.id}/assigned", team_id: team.id
      expect(response).to have_http_status 403
    end

    it "should 404 if project or team not exists" do
      project = create :projectOne
      admin = create :admin
      login admin

      post "/projects/#{project.id}/assigned", team_id: 123
      expect(response).to have_http_status 404
    end
  end
end
