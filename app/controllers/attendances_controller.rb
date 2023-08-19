require "date"

class AttendancesController < ApplicationController
  before_action :set_group, only: %i[new create]
  before_action :set_month, only: %i[create show]
  before_action :set_group_sesired_holidays, only: [:create]
  
  def index
  end

  def new
  end

  def create
    @days = []
    @month.all_month.each do |day|
      @days << day
    end
    # binding.pry
    @days.each do |day|
      @group.users.each do |user|
        @attendance = Attendance.new
        @attendance.working_day = day
        @attendance.user_id = user.id
        @attendance.group_id = @group.id
        if day.wday == 0 || day.wday == 6
          @attendance.working_status_id = 1
        elsif user_holiday_present(day, user)
          @attendance.working_status_id = 2
        else
          @attendance.working_status_id = 3
        end
        @attendance.save
      end
    end
    redirect_to attendance_path(Attendance.where(group_id: @group.id).find_by(working_day: Date.parse("#{@month.beginning_of_month}")).id)
  end

  def show
    @group_users = User.all
    @attendances = Attendance.where(user_id: @group_users.ids).where("working_day >= ?", Date.parse("#{@month.beginning_of_month}")).where("working_day <= ?", Date.parse("#{@month.end_of_month}")).order(user_id: :asc).order(working_day: :asc)
    @days = []
    @attendances.first.working_day.all_month.each do |d|
      @days << d
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_sesired_holidays
    set_group
    @group_sesired_holidays = SesiredHoliday.where(group_id: @group.id).where("my_holiday >= ?", Date.parse((@month.beginning_of_month).to_s)).where("my_holiday <= ?", Date.parse((@month.end_of_month).to_s)).reorder(my_holiday: :asc)
  end

  def set_month
    if params["month(1i)"].present?
      @month = Date.parse("#{params["month(1i)"]}-#{params["month(2i)"]}-#{params["month(3i)"]}")
    else
      @month = Date.parse("#{Attendance.find(params[:id]).working_day}")
    end
  end

  def user_holiday_present(a_day, user)
    set_group_sesired_holidays
    user_holidays = @group_sesired_holidays.where(user_id: user.id)
    user_holidays.each_with_index do |holiday, i|
      binding.pry
      if holiday.my_holiday == a_day.day
        return true
      elsif i == user_holidays.length - 1
        false
      end
    end
  end 
end
