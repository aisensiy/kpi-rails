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
end
