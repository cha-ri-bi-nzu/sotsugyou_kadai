require "date"
require 'holiday_japan'

class AttendancesController < ApplicationController
  before_action :set_group, only: %i[index new create]
  before_action :admin_or_owner, only: %i[new create]
  before_action :set_month, only: %i[create show]
  before_action :set_days, only: %i[create show]
  
  def index
    @month = Date.current
    set_month if params["month(1i)"].present?
    set_days
    @attendances = Attendance.group_data(@group.id).month_data(@month).order(working_day: :asc)
    user_ids = @attendances.pluck(:user_id).uniq
    @group_users = User.find(user_ids)
  end

  def new
  end

  def create
    group_desired_holidays = DesiredHoliday.group_data(@group.id).where("my_holiday >= ?", Date.parse("#{@month.beginning_of_month}")).where("my_holiday <= ?", Date.parse("#{@month.end_of_month}")).reorder(my_holiday: :asc)
    @days.each do |day|
      @group.users.each do |user|
        attendance = Attendance.new
        attendance.working_day = day
        attendance.user_id = user.id
        attendance.group_id = @group.id
        user_holidays = group_desired_holidays.where(user_id: user.id)
        if day.wday == 0 || day.wday == 6 || HolidayJapan.check(day)
          attendance.working_status_id = 1
        elsif user_holidays.present? && user_holidays.any? { |holiday| holiday.my_holiday == day }
          attendance.working_status_id = 2
        else
          attendance.working_status_id = 3
        end
        before_attendances = @group.attendances.where(user_id: user.id, working_day: day)
        before_attendances.destroy_all if before_attendances.present?
        attendance.save # unless Grouping.find_by(user_id: user.id, group_id: @group.id).leave_group  (if文で消してelseの時保存したが良い？)
      end
    end
    attendance_id = Attendance.group_data(@group.id).find_by(working_day: Date.parse("#{@month.beginning_of_month}")).id
    redirect_to attendance_path(attendance_id)
  end

  def show
    @group = Attendance.find(params[:id]).group
    @attendances = Attendance.group_data(@group.id).month_data(@month).order(working_day: :asc)
    user_ids = @attendances.pluck(:user_id).uniq
    @group_users = User.find(user_ids)
  end

  private
  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_month
    if params["month(1i)"].present?
      @month = Date.parse("#{params["month(1i)"]}-#{params["month(2i)"]}-#{params["month(3i)"]}")
    elsif params[:month].present?
      @month = Date.parse(params[:month])
    else
      @month = Date.parse("#{Attendance.find(params[:id]).working_day}")
    end
  end

  def set_days
    @days = []
    @month.all_month.each do |day|
      @days << day
    end
  end

  def admin_or_owner
    redirect_to group_path(@group), notice: "シフト作成機能はオーナーと管理者のみ使用できます" unless current_user == @group.owner || current_user.admin
  end
end
