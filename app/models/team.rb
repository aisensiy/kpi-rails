class Team
  include Mongoid::Document

  field :name, type: String

  validates_presence_of :name

  has_many :assignments
  has_many :project_assignments

  def assign_to project
    self.project_assignments.where(current: true).update_all(current: false)
    ProjectAssignment.create(team: self, project: project)
  end

  def assign
    self.project_assignments.where(current: true).first.try(:project)
  end
end
