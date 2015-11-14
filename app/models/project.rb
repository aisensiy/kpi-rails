class Project
  include Mongoid::Document
  field :name, type: String

  has_many :tasks
  validates_presence_of :name
  has_many :project_assignments

  def team
    project_assignments.where(current: true).team
  end
end
