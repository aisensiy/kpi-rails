json.extract! @kpi, :id, :created_at, :from, :to, :value
json.member_id @kpi.member_id if @kpi.for_member?
json.team_id @kpi.team_id if @kpi.for_team?