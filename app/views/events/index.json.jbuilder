json.array! @events do |event|
  json.extract! event, :id, :status, :created_at, :member_id, :team_id
  json.transfer_to event[:transfer_to] if event[:transfer_to]
  json.assign_to event[:assign_to] if event[:assign_to]
end
