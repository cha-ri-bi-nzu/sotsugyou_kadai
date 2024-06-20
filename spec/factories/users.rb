FactoryBot.define do
  factory :user do
    id {1}
    name {"admin_user"}
    sequence(:email) { |n| "test#{n}@example.com" }
    password {"adminadmin"}
    admin {true}
  end
  factory :second_user, class: User do
    id {2}
    name {'user_name2'}
    sequence(:email) { |n| "test1#{n}@example.com" }
    password {'bbbbbb'}
    admin {false}
  end
  factory :third_user, class: User do
    id {3}
    name {'user_name3'}
    sequence(:email) { |n| "test2#{n}@example.com" }
    password {'cccccc'}
    admin {false}
  end
  factory :fourth_user, class: User do
    id {4}
    name {'user_name4'}
    sequence(:email) { |n| "test3#{n}@example.com" }
    password {'dddddd'}
    admin {false}
  end
end
