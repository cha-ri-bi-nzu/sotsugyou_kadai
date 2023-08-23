class TopsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @group = current_user.groupings.where(leave_group: false)
  end
end
