require "date"

class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def user_holiday_present(group_sesired_horydays, a_day, user)
    user_holidays = group_sesired_holidays.where(user_id: user.id)
    user_holidays.each_with_index do |holiday, i|
      if holiday.my_holiday == a_day.day
        return true
      elsif i == user_holidays.length - 1
        false
      end
    end
  end 
end
