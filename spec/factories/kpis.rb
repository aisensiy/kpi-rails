FactoryGirl.define do
  factory :member_kpi, class: Kpi do
    from "2015-11-14 16:14:46"
    to "2015-11-14 16:14:46"
    value 100
    category "for_member"
  end

  factory :team_kpi, class: Kpi do
    from "2015-11-14 16:14:46"
    to "2015-11-14 16:14:46"
    category "for_team"
    value 100
  end
end
