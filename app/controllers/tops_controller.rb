class TopsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    grouping = current_user.groupings.where(leave_group: false) if user_signed_in?
    if grouping.present?
      @group = Group.select(:id, :name).where(id: grouping.pluck(:group_id)).where(invalid_group: false)
    else
      nil
    end
  end
end
