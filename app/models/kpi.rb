class Kpi
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum

  enum :category, [:for_member, :for_team]
  field :from, type: Time
  field :to, type: Time
  field :member_id, type: String
  field :team_id, type: String
  field :value, type: Integer
end
