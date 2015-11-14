require 'rails_helper'

RSpec.describe "Teams", type: :request do
  describe "create team" do
    it 'should create team with admin login' do
      admin = create(:admin)
      login(admin)
      team = attributes_for :teamOne
      post "/teams", team: team
      expect(response).to have_http_status(:created)
      team = Team.first
      expect(response.headers["Location"]).to end_with team_path(team)
    end

    it "should get 400 with bad request" do
      admin = create(:admin)
      login(admin)
      post "/teams", team: {other: 123}
      expect(response).to have_http_status(400)
    end

    it 'should forbidden without admin login' do
      employee = create(:employee)
      login(employee)
      team = attributes_for :teamOne
      post "/teams", team: team
      expect(response).to have_http_status(403)
    end
  end

  describe "get one team" do
    it "should get one team" do
      team = create :teamOne
      employee = create :employee
      login(employee)
      get "/teams/#{team.id}"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data["name"]).to eq(team.name)
    end

    it 'should 404 with team not found' do
      employee = create :employee
      login(employee)
      get "/teams/1"
      expect(response).to have_http_status(404)
    end
  end

  describe "list teams" do
    it 'should get a list of teams' do
      team = create :teamOne
      5.times do |i|
        create :teamOne, name: "team_#{i}"
      end

      employee = create :employee
      login(employee)

      get "/teams"
      expect(response).to have_http_status(200)
      data = JSON.parse(response.body)
      expect(data.size).to eq(6)
      first = data[0]
      expect(first["url"]).to end_with("/teams/#{team.id}")
    end
  end
end
