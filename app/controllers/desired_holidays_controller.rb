class DesiredHolidaysController < ApplicationController
  before_action :desired_holiday_current_user_or_admin, only: %i[new create destroy]

  def new
    @desired_holiday = DesiredHoliday.new
    @group = Group.find(params[:group_id])
  end

  def create
    @desired_holiday = User.find(params[:desired_holiday][:user_id]).desired_holidays.new(desired_holiday_params)
    if @desired_holiday.save
      @grouping = Grouping.find_by(user_id: params[:desired_holiday][:user_id], group_id: params[:desired_holiday][:group_id])
      redirect_to grouping_path(@grouping), notice: "『#{@desired_holiday.my_holiday}』で希望休申請しました。"
    else
      flash.now[:alert] = "申請に失敗しました"
      render :new
  end

  def destroy
    @desired_holiday = DesiredHoliday.find(params[:id])
    destroy_holiday = @desired_holiday.my_holiday
    @desired_holiday.destroy
    redirect_to grouping_path(params[:grouping_id]), notice: "#{destroy_holiday}の希望休が取り消されました"
  end

  private
  def desired_holiday_params
    params.require(:desired_holiday).permit(:user_id, :group_id, :my_holiday)
  end

  def desired_holiday_current_user_or_admin
    @user = User.find(params[:user_id]) if params[:user_id].present?
    @user = User.find(params[:desired_holiday][:user_id]) if params[:desired_holiday].present?
    redirect_to user_path(current_user), notice: "他のユーザーの希望休は申請出来ません" unless current_user == @user || current_user.admin
  end
end
