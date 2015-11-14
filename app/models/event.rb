class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  include Mongoid::Attributes::Dynamic

  enum :status, [:created, :transferred, :assigned, :cancelled, :finished]
  field :task_id, type: String
  field :team_id, type: String
  field :member_id, type: String

  validates_presence_of :task_id

  belongs_to :member
  belongs_to :team

  belongs_to :task
end
