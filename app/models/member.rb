class Member
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  include ActiveModel::SecurePassword

  enum :role, [:manager, :employee, :admin]

  field :name, type: String
  field :password_digest

  validates_presence_of :name, :password, :role
  has_many :assignments

  has_secure_password

  def assign_to team
    self.assignments.where(current: true).update_all(current: false)
    Assignment.create(team: team, member: self)
  end

  def assign
    assignments.where(current: true).first.try(:team)
  end
end
