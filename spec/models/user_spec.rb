require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    context '全ての情報が入力された場合' do
      it 'ユーザーが作成される' do
        user = User.new(name: 'aaaaaa', email: 'a@mail.com', password: 'aaaaaa')
        expect(user).to be_valid
      end
    end
    context 'ユーザー名が空の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: '', email: 'a@mail.com', password: 'aaaaaa')
        expect(user).not_to be_valid
      end
    end
    context 'メールアドレスが空の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: 'aaaaaa', email: '', password: 'aaaaaa')
        expect(user).not_to be_valid
      end
    end
    context 'パスワードが空の場合' do
      it 'バリデーションにひっかる' do
        user = User.new(name: 'aaaaaa', email: 'a@mail.com', password: '')
        expect(user).not_to be_valid
      end
    end
  end
end
