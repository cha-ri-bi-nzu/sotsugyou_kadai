class AttendancesController < ApplicationController
  def index
  end

  def new
    @group = Group.find(params[:group_id])
  end

  def create
    @group = Group.find(params[:group_id])
    month = "#{params["month(1i)"]}-#{params["month(2i)"]}-#{params["month(3i)"]}"
    @month = Date.parse(month)
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
