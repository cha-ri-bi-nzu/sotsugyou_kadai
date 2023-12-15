class GroupingsController < ApplicationController
  before_action :grouping_current_user_or_admin, only: [:show]

  def index
    @group = Group.find(params[:group_id]) if params[:group_id].present?
    @user = "メールアドレスでユーザーを探しましょう。"
    if params[:grouping].present?
      @group = Group.find(params[:grouping][:group_id])
      if params[:grouping][:email].present?
        @user = User.find_by(email: params[:grouping][:email])
        @grouping = Grouping.find_by(user_id: @user.id, group_id: @group.id)
      else
        flash[:notice] = "メールアドレスを入力して検索してください。"
        render :index
      end
    end
  end

  def create
    grouping = Grouping.create(user_id: params[:user_id], group_id: params[:group_id])
    redirect_to group_path(grouping.group_id), notice: "#{grouping.user.name}さんが参加されました。"
  end

  def show
    @group = Group.find(@grouping.group_id)
    @desired_holidays = @user.desired_holidays.where(user_id: @user.id, group_id: @grouping.group_id).order(my_holiday: :asc)
  end
  
  def update
    if params[:id].present? && params[:user_id].present?
      grouping = Grouping.find_by(user_id: params[:user_id], group_id: params[:id])
      in_or_out(grouping)
      if params[:user_id] == current_user.id
        redirect_to user_path(params[:user_id]), notice: owner_or_people(grouping)
      else
        redirect_to group_path(params[:id]), notice: owner_or_people(grouping)
      end
    elsif params[:id].present?
      grouping = Grouping.find(params[:id])
      in_or_out(grouping)
      redirect_to group_path(grouping.group_id), notice: "#{User.find(grouping.user_id).name}さんが再招待されました。"
    else
      flash[:alert] = "ユーザーはグループに所属していません。"
      redirect_to group_path(params[:id])
    end
  end

  def destroy
    grouping = Grouping.find_by(group_id: params[:id],user_id: params[:user_id]).destroy
    redirect_to group_path(params[:id]), notice: "#{grouping.user.name}さんが完全に除名されました。"
  end

  private
  def in_or_out(grouping)
    new_leave_group = !grouping.leave_group
    if new_leave_group
      grouping.update_attribute(:leave_group, new_leave_group)
    else
      grouping.update(leave_group: new_leave_group)
    end
  end

  def owner_or_people(grouping)
    if grouping.group.owner == grouping.user
      "オーナーは脱退できません！" 
    elsif params[:user_id] == current_user.id
      "#{@group.name}を脱退しました。"  # 上書きされているので、要修正
    else
      "#{User.find(params[:user_id]).name}さんが除名されました。"
    end
  end

  def grouping_current_user_or_admin
    @grouping = Grouping.find(params[:id])
    @user = User.find(@grouping.user_id)
    redirect_to user_path(current_user), notice: "他のユーザーの希望休は閲覧出来ません" unless current_user == @user || current_user.admin
  end
end
