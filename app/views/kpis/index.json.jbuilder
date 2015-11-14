json.array!(@kpis) do |kpi|
  json.extract! kpi, :id, :created_at, :from, :to, :value, :member_id, :team_id
end
