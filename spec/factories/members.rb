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

  factory :admin, class: Member do
    name "admin"
    password "123"
    role :admin
  end
end