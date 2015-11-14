require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "create new member" do
    it "create new member with valide input" do
      post "/members", member: { name: 'abc', password: 'bb', role: 'employee' }
      expect(response).to have_http_status(201)
      p (response.headers["Location"])
    end

    it 'should fail with invalid input' do
      p Member.count
      post "/members", member: {name: 'bb'}
      expect(response).to have_http_status(400)
    end
  end
end
