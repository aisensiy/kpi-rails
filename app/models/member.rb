class Member
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  include ActiveModel::SecurePassword

  enum :role, [:manager, :employee, :admin]

  field :name, type: String
  field :password_digest

  validates_presence_of :name, :password, :role

  has_secure_password
end
