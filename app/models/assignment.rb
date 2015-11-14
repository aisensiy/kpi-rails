class Assignment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :team_id, type: String
  field :member_id, type: String
  field :current, type: Boolean, default: true

  belongs_to :member
  belongs_to :team

  validates_presence_of :member_id, :team_id

end
