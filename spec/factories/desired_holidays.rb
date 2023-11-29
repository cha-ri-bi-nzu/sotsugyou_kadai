FactoryBot.define do
  factory :desired_holiday do
    my_holiday { "2023-08-27" }
    group { 1 }
    user { 1 }
  end
  factory :second_desired_holiday, class: DesiredHoliday do 
    my_holiday { "2023-08-28" }
    group { 1 }
    user { 1 }
  end
  factory :third_desired_holiday, class: DesiredHoliday do 
    my_holiday { "2023-09-29" }
    group { 1 }
    user { 1 }
  end
  factory :fourth_desired_holiday, class: DesiredHoliday do 
    my_holiday { "2023-08-29" }
    group { 1 }
    user { 2 }
  end
  factory :fifth_desired_holiday, class: DesiredHoliday do 
    my_holiday { "2023-08-26" }
    group { 2 }
    user { 1 }
  end
end
