require 'rails_helper'

RSpec.describe Team, type: :model do
  it 'should assign to one project' do
    team = create :teamOne
    project_one = create :projectOne
    project_two = create :projectTwo
    expect(team.assign).to eq(nil)
    team.assign_to project_one
    expect(team.assign).to eq(project_one)

    team.assign_to project_two
    expect(team.assign).to eq(project_two)
  end
end
