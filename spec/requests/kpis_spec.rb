require 'rails_helper'

RSpec.describe "Kpis", type: :request do
  describe "create kpi" do
    it "should create member kpi success" do
      admin = create :admin
      login admin
      member = create :employee
      member_kpi = attributes_for :member_kpi
      member_kpi[:member_id] = member.id
      post "/kpis", kpi: member_kpi
      expect(response).to have_http_status 201
    end

    it "should create team kpi success" do
      admin = create :admin
      login admin
      team = create :teamOne
      team_kpi = attributes_for :team_kpi
      team_kpi[:team_id] = team.id
      post "/kpis", kpi: team_kpi
      expect(response).to have_http_status 201
    end

    it "should 403 if not admin" do
      admin = create :employee
      login admin
      team = create :teamOne
      team_kpi = attributes_for :team_kpi
      team_kpi[:team_id] = team.id
      post "/kpis", kpi: team_kpi
      expect(response).to have_http_status 403
    end
  end

  describe "get one kpi" do
    it "should get one" do
      admin = create :admin
      login admin

      team = create :teamOne
      team_kpi = create :team_kpi, team_id: team.id

      get "/kpis/#{team_kpi.id.to_s}"
      expect(response).to have_http_status 200
      data = JSON.parse response.body
      expect(data["team_id"]).to eq(team.id.to_s)
    end
  end

  describe "list kpis" do
    it "should list all" do
      admin = create :admin
      login admin

      team = create :teamOne
      create :team_kpi, team_id: team.id
      create :team_kpi, team_id: team.id
      create :team_kpi, team_id: team.id

      get "/kpis"
      expect(response).to have_http_status 200
      data = JSON.parse response.body
      expect(data.size).to eq(3)
    end
  end
end
