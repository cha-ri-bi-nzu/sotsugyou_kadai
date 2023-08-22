require 'rails_helper'

RSpec.describe 'ユーザー管理機能', type: :system do
  describe '新規作成機能' do
    context 'ユーザーを新規作成した場合' do
      it 'ユーザーのマイページに遷移される' do
        visit new_user_registration_path
        fill_in "user_name", with: 'admin_user'
        fill_in "user_email", with: 'aasdsadadaa@mail.com'
        fill_in "user_password", with: 'adminadmin'
        fill_in "user_password_confirmation", with: 'adminadmin'
        click_button "アカウント登録"
        expect(page).to have_content 'admin_user'
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'ログアウト'
        expect(page).to have_content 'アカウント登録が完了しました。'
      end
    end
  end
  describe 'ログイン要請機能' do
    context 'ログインせずにマイページにアクセスした場合' do
      it 'ログイン画面に遷移される' do
        visit user_path(1)
        expect(current_path).to eq "/users/sign_in"
        expect(page).to have_content '新規登録'
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end
    end
  end
end

RSpec.describe 'セッション機能', type: :system do
  describe 'ログイン機能' do
    let!(:user) {FactoryBot.create(:user)}
    context 'ログインをした場合' do
      it "ログイン状態で自分のマイページに遷移される" do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user[password]", with: 'adminadmin'
        click_button "ログイン"
        expect(current_path).to eq user_path(user.id)
        expect(page).to have_content 'user_name2さんのマイページ'
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'ログアウト'
        expect(page).to have_content 'ログインしました。'
      end
    end
    let!(:second_user) {FactoryBot.create(:second_user)}
    before do
      visit new_user_session_path
      fill_in "user_email", with: second_user.email
      fill_in "user[password]", with: 'bbbbbb'
      click_button "ログイン"
    end
    context 'ログアウトをした場合' do
      it "ログアウト状態でTOPページに遷移される" do
        click_link "ログアウト"
        expect(current_path).to eq root_path
        expect(page).to have_content '新規登録'
        expect(page).to have_content 'ログイン'
        expect(page).to have_content 'まずは無料登録から'
        expect(page).to have_content 'アカウントをお持ちの方はコチラ！'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
  describe 'ユーザー確認機能' do
    let!(:user) {FactoryBot.create(:user, admin: false)}
    let!(:second_user) {FactoryBot.create(:second_user)}
    before do
      visit new_user_session_path
      fill_in "user_email", with: second_user.email
      fill_in "user[password]", with: 'bbbbbb'
      click_button "ログイン"
    end
    context '一般ユーザーが他のユーザーのマイページにアクセスした場合' do
      it "自分のマイページに遷移される" do
        visit user_path(user.id)
        expect(current_path).to eq user_path(second_user.id)
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'ログアウト'
        expect(page).to have_content 'admin_userさんのマイページ'
        expect(page).to have_content '他のユーザーのページは閲覧できません'
      end
    end
  end
end

RSpec.describe '管理者機能', type: :system do
  describe '管理権限確認機能' do
    let!(:user) {FactoryBot.create(:user)}
    context '管理ユーザーが管理画面にアクセスした場合' do
      before do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user_password", with: 'adminadmin'
        click_button "ログイン"
      end
      it '管理画面に遷移される' do
        click_link "管理画面"
        expect(current_path).to eq rails_admin_path
        expect(page).to have_content 'サイト管理'
        expect(page).to have_content 'モデル名'
        expect(page).to have_content 'レコード数'
      end
    end
  end
  describe 'ユーザー管理機能' do
    let!(:user) {FactoryBot.create(:user)}
    let!(:second_user) {FactoryBot.create(:second_user)}
    before do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user_password", with: 'adminadmin'
      click_button "ログイン"
      click_link "管理者画面"
    end
    context '管理ユーザーがユーザーの詳細画面にアクセスした場合' do
      it "該当のユーザー詳細画面に遷移される" do
        visit user_path(second_user.id)
        expect(current_path).to eq user_path(second_user.id)
        expect(page).to have_content 'user_name2さんのマイページ'
        expect(page).to have_content '管理者画面'
        expect(page).to have_content 'マイページ'
        expect(page).to have_content 'ログアウト'
      end
    end
  end
end