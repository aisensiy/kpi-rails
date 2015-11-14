require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "create new member" do
    it "should 403 without admin login" do
      employee = create :employee
      post "/members/login", { password: employee.password, name: employee.name }
      post "/members", member: { name: 'abc', password: 'bb', role: 'employee' }
      expect(response).to have_http_status(403)
    end

    it "create new member with valide input" do
      admin = create :admin
      post "/members/login", { password: admin.password, name: admin.name }
      post "/members", member: { name: 'abc', password: 'bb', role: 'employee' }
      member = Member.order_by(created_at: :desc).first
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/members/#{member.id}")
    end

    it 'should fail with invalid input' do
      admin = create :admin
      post "/members/login", { password: admin.password, name: admin.name }
      post "/members", member: {name: 'bb'}
      expect(response).to have_http_status(400)
    end
  end

  describe "login" do
    it "should 400 if wrong password or username" do
      employee = create(:employee)
      post "/members/login", { name: employee.name, password: "ddd" }
      expect(response).to have_http_status(400)
    end
  end

  describe "logout" do
    it "should logout" do
      admin = create :admin
      post "/members/login", { password: admin.password, name: admin.name }
      post "/members/logout"
      expect(response).to have_http_status(200)
      post "/members", member: {name: 'bb'}
      expect(response).to have_http_status(401)
    end
  end
end
