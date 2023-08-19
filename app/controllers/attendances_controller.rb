class AttendancesController < ApplicationController
  def index
  end

  def new
    @group = Group.find(params[:group_id])
  end

  def create
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
