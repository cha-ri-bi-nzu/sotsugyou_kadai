FactoryBot.define do
  factory :desired_holiday do
    my_holiday { "2023-08-27" }
    user { nil }
    group { nil }
  end
end
