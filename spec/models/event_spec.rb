require 'rails_helper'

RSpec.describe Event, type: :model do
  it "should list current task of team" do
    team = create :teamOne
    team2 = create :teamTwo

    manager = create :manager, name: 'a'
    manager2 = create :manager, name: 'b'

    manager.assign_to team
    manager2.assign_to team2

    project = create :projectOne
    team.assign_to project

    task1 = Task.create name: 'a', description: 'b', member_id: manager.id, team_id: team.id
    task2 = Task.create name: 'b', description: 'b', member_id: manager.id, team_id: team.id

    task2.transfer manager, team2

    expect(Event.task_for_team team.id).to eq([task1])
    expect(Event.task_for_team team2.id).to eq([task2])
  end
end
