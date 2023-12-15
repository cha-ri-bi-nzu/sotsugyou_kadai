require 'holiday_japan'

FactoryBot.define do
  (1..3).each do |i|
    (1..31).each do |j|
      factory :"user#{i}_attendance#{j}", class: Attendance do
        working_day { Date.parse("2023-08-#{j}") }
        if HolidayJapan.check(Date.parse("2023-08-#{j}")) || [5, 6].include?(Date.parse("2023-08-#{j}").wday)
          working_status_id { 1 }
        elsif DesiredHoliday.find_by(user_id: i, group_id: 1, my_holiday: Date.parse("2023-08-#{j}"))
          working_status_id { 2 }
        else
          working_status_id { 3 }
        end
        group_id { 100 }
        user_id { i }
      end
    end
  end
end
