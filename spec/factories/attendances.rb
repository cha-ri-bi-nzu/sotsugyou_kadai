FactoryBot.define do
  factory :attendance do
    working_day { "2023-08-27" }
    working_status_id { 0 }
    group { 1 }
    user { 1 }
  end
  factory :second_attendance, class Attendance do 
    working_day { "2023-08-28" }
    working_status_id { 1 }
    group { 1 }
    user { 1 }
  end
end
