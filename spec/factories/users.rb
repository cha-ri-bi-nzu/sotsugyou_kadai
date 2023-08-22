FactoryBot.define do
  factory :user do
    name {"admin_user"}
    sequence(:email) { |n| "test#{n}@example.com" }
    password {"adminadmin"}
    admin {true}
  end
  factory :second_user, class: User do
    name {'user_name2'}
    sequence(:email) { |n| "test#{n}@example.com" }
    password {'bbbbbb'}
    admin {false}
  end
end
