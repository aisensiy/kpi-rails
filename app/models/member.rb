class Member
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :name, type: String
  field :password_digest
  field :role, type: String

  validates_presence_of :name, :password, :role

  has_secure_password
end
