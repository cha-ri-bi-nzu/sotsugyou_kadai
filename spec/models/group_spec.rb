require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'バリデーションのテスト' do
    let!(:user){FactoryBot.create(:user)}
    context '全ての情報が入力された場合' do
      it 'グループが作成される' do
        group = Group.new(name: 'aaaaaa', owner_id: user.id)
        expect(group).to be_valid
      end
    end
    context 'グループ名が空の場合' do
      it 'バリデーションにひっかる' do
        group = Group.new(name: '', owner_id: user.id)
        expect(group).not_to be_valid
      end
    end
  end
end
