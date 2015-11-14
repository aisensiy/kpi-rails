class Task
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :team_id, type: String
  field :member_id, type: String
  field :project_field, type: String

  belongs_to :project
  has_many :events

  validates_presence_of :name, :description

  after_create :create_task_created_event

  def create_task_created_event
    self.events.create task: self, member_id: self.member_id, team_id: self.team_id, status: :created
  end

  def current_team
    event = events.order(created_at: :desc).first
    if event.transferred?
      Team.find(event.transfer_to)
    else
      Team.find(event.team_id)
    end
  end

  def status
    event = events.where(current: true).first
    event.status
  end

  def assign
    event = events.order(status: :assigned).try(:first)
    if event.nil?
      nil
    else
      Member.find(event.assign)
    end
  end

  def cancel(by)
    self.events.where(current: true).update_all(current: false)
    self.events.create task: self, member: by, team: by.assign, status: :cancelled
  end

  def transfer(by, to)
    self.events.where(current: true).update_all(current: false)
    self.events.create task: self, member: by, team: by.assign, transfer_to: to.id, status: :transferred
  end

  def assign_to(by, to)
    self.events.where(current: true).update_all(current: false)
    self.events.create task: self, member: by, team: current_team, assign_to: to.id, status: :assigned
  end

  def finish(by)
    self.events.where(current: true).update_all(current: false)
    self.events.create task: self, member: by, team: current_team, status: :finished
  end
end
