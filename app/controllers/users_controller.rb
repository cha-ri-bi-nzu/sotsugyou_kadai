class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    current_user_or_admin
    @group = groups_name(@user)
  end

  private
  def groups_name(user)
    grouping = Grouping.where(user_id: user.id).where(leave_group: false)
    if grouping.present?
      Group.select(:id, :name).where(id: grouping.pluck(:group_id))
    else
      nil
    end
  end

  def current_user_or_admin
    redirect_to user_path(current_user.id), notice: "他のユーザーのページは閲覧できません" unless @user == current_user || current_user.admin
  end
end
