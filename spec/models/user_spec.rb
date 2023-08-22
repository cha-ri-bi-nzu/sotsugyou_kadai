require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザー名が空の場合' do
      it 'バリデーションにひっかる' do
        user = FactoryBot.create(:user, name: '')
        expect(user).not_to be_valid
      end
    end
    # context 'メールアドレスが空の場合' do
    #   it 'バリデーションにひっかる' do
    #     task = Task.new(title: '', content: '失敗テスト')
    #     expect(task).not_to be_valid
    #   end
    # end
    # context 'パスワードが空の場合' do
    #   it 'バリデーションにひっかる' do
    #     task = Task.new(title: '', content: '失敗テスト')
    #     expect(task).not_to be_valid
    #   end
    # end
  end
end
