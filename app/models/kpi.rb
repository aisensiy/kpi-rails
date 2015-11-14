class Kpi
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  enum :type, [:member, :team]
  field :from, type: Time
  field :to, type: Time
  field :member_id, type: String
  field :team_id, type: String
end
