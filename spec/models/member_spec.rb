require 'rails_helper'

RSpec.describe Member, type: :model do
  it 'should create new assignment' do
    member = create(:manager)
    team = create(:teamOne)
    team2 = create(:teamTwo)
    member.assign_to team
    expect(member.assign).to eq(team)

    member.assign_to team2
    expect(member.assign).to eq(team2)
  end
end
