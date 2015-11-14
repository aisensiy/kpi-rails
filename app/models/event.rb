class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  enum :status, [:created, :transferred, :assigned, :cancelled, :finished]
  field :task_id, type: String
  field :team_id, type: String
  field :transfer_to, type: String
  field :assign_to, type: String
  field :current, type: Boolean, default: true
  field :member_id, type: String

  validates_presence_of :task_id

  belongs_to :member
  belongs_to :team

  belongs_to :task

  def self.task_for_member member_id
    Event.where(current: true).any_of({assign_to: member_id}, {member_id: member_id}).map { |event| Task.find(event.task_id) }
  end

  def self.task_for_team team_id
    Event.where(current: true).any_of(
        {team_id: team_id, :status.ne => :transferred},
        {transfer_to: team_id}).map { |event| Task.find(event.task_id) }
  end
end
