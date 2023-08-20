require "date"
require 'holiday_japan'

class AttendancesController < ApplicationController
  before_action :set_group, only: %i[index new create]
  before_action :set_month, only: %i[create show]
  
  def index
    @month = Date.current >> 1
    set_month if params["month(1i)"].present?
    @days = []
    @month.all_month.each do |day|
      @days << day
    end
    @users = @group.users
  end

  def new
  end

  def create
    @days = []
    @month.all_month.each do |day|
      @days << day
    end
    @group_sesired_holidays = SesiredHoliday.where(group_id: @group.id).where("my_holiday >= ?", Date.parse("#{@month.beginning_of_month}")).where("my_holiday <= ?", Date.parse("#{@month.end_of_month}")).reorder(my_holiday: :asc)
    @days.each do |day|
      @group.users.each do |user|
        @attendance = Attendance.new
        @attendance.working_day = day
        @attendance.user_id = user.id
        @attendance.group_id = @group.id
        user_holidays = @group_sesired_holidays.where(user_id: user.id)
        if day.wday == 0 || day.wday == 6 || HolidayJapan.check(day)
          @attendance.working_status_id = 1
        elsif user_holidays.present? && user_holidays.any? { |holiday| holiday.my_holiday == day }
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
    @group = Attendance.find(params[:id]).group
    @attendances = Attendance.where(group_id: @group.id).where("working_day >= ?", Date.parse("#{@month.beginning_of_month}")).where("working_day <= ?", Date.parse("#{@month.end_of_month}")).order(user_id: :asc).order(working_day: :asc)
    user_ids = @attendances.plack(:user_id).uniq
    @group_users = User.find(user_ids)
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

  def set_month
    if params["month(1i)"].present?
      @month = Date.parse("#{params["month(1i)"]}-#{params["month(2i)"]}-#{params["month(3i)"]}")
    else
      @month = Date.parse("#{Attendance.find(params[:id]).working_day}")
    end
  end
end
