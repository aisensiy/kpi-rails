require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'should should create a task created event after create task' do
    project = create :projectOne
    task = build :task, project: project
    task.save
    expect(task.events.size).to eq(1)
    event = task.events.first
    expect(event.status).to eq(:created)
  end

  it "should cancel task and create cancel event" do
    project = create :projectOne
    team = create :teamOne
    member = create :memberOne
    member.assign_to team
    team.assign_to project

    task = build :task, project: project, team_id: team.id
    task.save
    task.cancel(member)
    expect(task.events.size).to eq(2)
    expect(task.status).to eq(:cancelled)
  end

  it 'should transfer task to other team' do
    project = create :projectOne
    team = create :teamOne
    member = create :memberOne
    member.assign_to team
    team.assign_to project

    task = build :task, project: project, team_id: team.id
    task.save

    team2 = create :teamTwo
    task.transfer(member, team2)
    expect(task.status).to  eq(:transferred)
    expect(task.current_team).to eq(team2)
  end
end
