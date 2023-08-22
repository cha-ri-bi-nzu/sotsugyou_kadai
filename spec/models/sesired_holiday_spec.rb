require 'rails_helper'

RSpec.describe SesiredHoliday, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user){FactoryBot.create(:user)}
    let!(:group){FactoryBot.create(:group, owner_id: user.id)}
    context '全ての情報が入力された場合' do
      it '希望休が作成される' do
        sesired_holiday = SesiredHoliday.new(my_holiday: '2023-10-01', user: user, group: group)
        expect(sesired_holiday).to be_valid
      end
    end
    context '希望休の日付が選択されていない場合' do
      it '希望休が作成さない' do
        sesired_holiday = SesiredHoliday.new(my_holiday: '', user: user, group: group)
        expect(sesired_holiday).not_to be_valid
      end
    end
  end
end
