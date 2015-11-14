class ProjectAssignment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :team_id, type: String
  field :project_id, type: String
  field :current, type: Boolean, default: true

  belongs_to :team
  belongs_to :project

  validates_presence_of :team_id, :project_id
end
