class Task
  include Mongoid::Document
  field :name, type: String
  field :description, type: String

  embedded_in :project
  has_many :events

  validates_presence_of :name, :description
end
