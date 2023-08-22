require "date"

class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update change_owner group_sesired_holiday invalid destroy]
  before_action :admin_or_owner, only: %i[edit update change_owner group_sesired_holiday invalid]
  before_action :your_group_and_group_present, only: %i[show edit update change_owner invalid]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    if @group.save
      @group.groupings.create(user: @group.owner)
      redirect_to group_path(@group), notice: "グループ『#{@group.name}』を作成しました。"
    else
      flash.now[:alert] = "グループ作成に失敗しました"
      render :new
    end
  end

  def show
    @groupings = @group.groupings.where(leave_group: false)
    @users = @groupings.map{|g| User.where(id: g.user_id)}.flatten
    @grouping_id = Grouping.find_by(user_id: current_user.id, group_id: @group.id)
  end

  def edit
  end

  def update
    before_name = @group.name
    if @group.update(group_params)
      redirect_to group_path(@group), notice: "#{before_name}を編集しました"
    else
      flash.now[:alert] = "編集に失敗しました"
      render :edit
    end
  end

  def change_owner
    before_owner = @group.owner.name
    if @group.update_attribute(:owner_id, params[:user_id])
      redirect_to @group, notice: "#{before_owner}さんから#{@group.owner.name}さんに、オーナー権限を譲渡しました"
    else
      flash.now[:alert] = "オーナー譲渡に失敗しました"
      render :show
    end
  end

  def group_sesired_holiday
    @month = Date.current >> 1
    if params[:group].present?
      month = "#{params[:group]["month(1i)"]}-#{params[:group]["month(2i)"]}-#{params[:group]["month(3i)"]}"
      @month = Date.parse(month)
    end
    @sesired_holidays = SesiredHoliday.where(group_id: params[:group_id]).where("my_holiday >= ?", Date.parse((@month.beginning_of_month << 1).to_s)).where("my_holiday <= ?", Date.parse((@month.end_of_month >> 1).to_s)).reorder(my_holiday: :asc)
  end

  def invalid
    if @group.update_attribute(:invalid_group, true)
      redirect_to user_path(current_user), notice: "#{@group.name}を削除しました"
    else
      flash.now[:alert] = "#{@group.name}の削除に失敗しました"
      render :show
    end
  end

  def destroy
    if current_user.admin
      group_name = @group.name
      @group.destroy
      redirect_to user_path(current_user), notice: "#{group_name}を完全に削除しました"
    else
      redirect_to user_path(current_user), notice: "管理者のみ削除が行えます"
    end
  end
  
  private
  def group_params
    params.require(:group).permit(:name, :owner_id)
  end

  def set_group
    @group = Group.find(params[:id]) if params[:id].present?
    @group = Group.find(params[:group_id]) if params[:group_id].present?
  end

  def admin_or_owner
    set_group
    redirect_to group_path(@group), notice: "この機能はオーナーと管理者のみ使用できます" unless current_user == @group.owner || current_user.admin
  end

  def your_group_and_group_present
    unless current_user.admin
      if @group.invalid_group
        redirect_to user_path(current_user), notice: "#{@group.name}は既に削除されています"
      else
        redirect_to user_path(current_user), notice: "所属していないグループにはアクセスできません" unless Grouping.where(user_id: current_user.id, group_id: @group.id, leave_group: false).present?
      end
    end
  end
end
