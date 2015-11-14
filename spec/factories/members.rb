FactoryGirl.define do
  factory :manager, class: Member do
    name "memberOne"
    password "123"
    role :manager
  end

  factory :employee, class: Member do
    name "memberTwo"
    password "123"
    role "employee"
  end
end
