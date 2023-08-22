require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user){FactoryBot.create(:user)}
    let!(:group){FactoryBot.create(:group, owner_id: user.id)}
    context '全ての情報が入力された場合' do
      it '希望休が作成される' do
        attendance = Attendance.new(working_day: '2023-10-01', working_status_id: 1, user: user, group: group)
        expect(attendance).to be_valid
      end
    end
    context '勤怠の日付が空の場合' do
      it '勤怠情報が作成されない' do
        attendance = Attendance.new(working_day: '', working_status_id: 1, user: user, group: group)
        expect(attendance).not_to be_valid
      end
    end
    context '勤務形態が空の場合' do
      it '勤怠情報が作成されない' do
        attendance = Attendance.new(working_day: '2023-10-01', working_status_id: nil, user: user, group: group)
        expect(attendance).not_to be_valid
      end
    end
  end
end
