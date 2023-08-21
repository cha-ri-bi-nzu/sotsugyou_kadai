class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
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
end
