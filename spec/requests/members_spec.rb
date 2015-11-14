require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "create new member" do
    it "create new member with valide input" do
      post "/members", member: { name: 'abc', password: 'bb', role: 'employee' }
      member = Member.order_by(created_at: :desc).first
      expect(response).to have_http_status(201)
      expect(response.headers['Location']).to end_with("/members/#{member.id}")
    end

    it 'should fail with invalid input' do
      post "/members", member: {name: 'bb'}
      expect(response).to have_http_status(400)
    end
  end
end
