require "date"

class AttendancesController < ApplicationController

  def index
  end

  def new
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id])
    @month = Date.parse("#{params["month(1i)"]}-#{params["month(2i)"]}-#{params["month(3i)"]}")
    @days = []
    @month.all_month.each do |day|
      @days << day
    end
    group_sesired_horydays = SesiredHoliday.where(group_id: @group.id).where("my_holiday >= ?", Date.parse((@month.beginning_of_month).to_s)).where("my_holiday <= ?", Date.parse((@month.end_of_month).to_s)).reorder(my_holiday: :asc)
    # binding.pry
    @days.each do |day|
      @group.users.each do |user|
        @attendance = Attendance.new
        @attendance.working_day = day
        @attendance.user_id = user.id
        @attendance.group_id = @group.id
        if day.wday == 0 || day.wday == 6
          @attendance.working_status_id = 1
        elsif user_holiday_present(group_sesired_horydays, day, user)
          @attendance.working_status_id = 2
        else
          @attendance.working_status_id = 3
        end
        @attendance.save
      end
    end
    redirect_to attendance_path(Attendance.where(group_id: @group.id).find_by(my_holiday: Date.parse("#{@month.beginning_of_month}")).id)
  end

  def show
    if params["month(1i)"].present?
      month = Date.parse("#{params["month(1i)"]}-#{params["month(2i)"]}-#{params["month(3i)"]}")
    else
      month = Date.parse("#{Attendance.find(params[:id])}")
    end
    @group_users = User.all
    @attendances = Attendance.where(user_id: @group_users.ids).where("working_day >= ?", DateTime.parse("#{@month.beginning_of_month}").beginning_of_month).where("working_day <= ?", DateTime.parse("#{@month.end_of_month}").end_of_month).order(user_id: :asc).order(working_day: :asc)
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
  
end
