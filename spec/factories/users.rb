FactoryBot.define do
  factory :user do
    name {"admin_user"}
    email {"admin@mail.com"}
    password {"adminadmin"}
    admin {true}
  end
end
