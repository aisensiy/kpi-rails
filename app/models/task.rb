class Task
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :team_id, type: String

  embedded_in :project
  has_many :events

  validates_presence_of :name, :description

  after_create :create_task_created_event

  def create_task_created_event
    self.events.create team_id: self.team_id, status: :created
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
    event = events.order(created_at: :desc).first
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
    self.events.create member: by, team: by.assign, status: :cancelled
  end

  def transfer(by, to)
    self.events.create member: by, team: by.assign, transfer_to: to.id, status: :transferred
  end

  def assign_to(by, to)
    self.events.create member: by, team: current_team, assign: to.id, status: :assigned
  end
end
