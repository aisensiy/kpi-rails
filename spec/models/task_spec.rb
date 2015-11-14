require 'rails_helper'

RSpec.describe Task, type: :model do

  before(:each) do
    @project = create :projectOne
    @team = create :teamOne
    @member = create :manager
    @member.assign_to @team
    @team.assign_to @project
  end

  it 'should should create a task created event after create task' do
    project = create :projectOne
    task = build :task, project: project
    task.save
    expect(task.events.size).to eq(1)
    event = task.events.first
    expect(event.status).to eq(:created)
  end

  it "should cancel task and create cancel event" do
    task = build :task, project: @project, team_id: @team.id
    task.save
    task.cancel(@member)
    expect(task.events.size).to eq(2)
    expect(task.status).to eq(:cancelled)
  end

  it 'should transfer task to other team' do
    task = build :task, project: @project, team_id: @team.id
    task.save

    team2 = create :teamTwo
    task.transfer(@member, team2)
    expect(task.status).to  eq(:transferred)
    expect(task.current_team).to eq(team2)
  end

  it 'should assign to member' do
    task = build :task, project: @project, team_id: @team.id
    task.save

    member2 = create :employee
    member2.assign_to @team
    task.assign_to(@member, member2)

    expect(task.status).to eq(:assigned)
    expect(task.assign).to eq(member2)
  end

  it "should finish task" do
    task = build :task, project: @project, team_id: @team.id
    task.save

    member2 = create :employee
    member2.assign_to @team
    task.assign_to(@member, member2)
    task.finish(@member)

    expect(task.status).to eq(:finished)
  end
end
