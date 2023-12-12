FactoryBot.define do
  factory :desired_holiday do
  id { 1 }
    my_holiday { "2023-08-27" }
    group_id { 100 }
    user_id { 1 }
  end
  factory :second_desired_holiday, class: DesiredHoliday do
    id { 2 }
    my_holiday { "2023-08-28" }
    group_id { 100 }
    user_id { 1 }
  end
  factory :third_desired_holiday, class: DesiredHoliday do
    id { 3 }
    my_holiday { "2023-09-29" }
    group_id { 100 }
    user_id { 1 }
  end
  factory :fourth_desired_holiday, class: DesiredHoliday do
    id { 4 }
    my_holiday { "2023-08-29" }
    group_id { 100 }
    user_id { 2 }
  end
  factory :fifth_desired_holiday, class: DesiredHoliday do
    id { 5 }
    my_holiday { "2023-08-26" }
    group_id { 101 }
    user_id { 1 }
  end
end
