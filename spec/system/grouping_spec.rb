require 'rails_helper'

RSpec.describe 'グルーピング機能', type: :system do
  let!(:user){FactoryBot.create(:user)}
  let!(:second_user){FactoryBot.create(:second_user)}
  let!(:third_user){FactoryBot.create(:third_user)}
  let!(:group){FactoryBot.create(:group, id: 100,owner_id: user.id)}
  let!(:grouping) {FactoryBot.create(:grouping, user_id: user.id, group_id: group.id)}
  let!(:second_grouping) {FactoryBot.create(:second_grouping, user_id: second_user.id, group_id: group.id)}
  let!(:third_grouping) {FactoryBot.create(:third_grouping, user_id: third_user.id, group_id: group.id)}
  describe '一般ユーザー機能' do
    before do
      visit new_user_session_path
      fill_in "user_email", with: second_user.email
      fill_in "user[password]", with: 'bbbbbb'
      click_button "ログイン"
      click_link "マイページ"
      click_link "test_group"
      binding.pry
    end
    context '一般ユーザーがグループを脱退した場合' do
      it 'グループから脱退(論理削除)しマイページに遷移する' do
        find("#leave-button#{second_user.id}").click
        expect(current_path).to eq user_path(second_user.id)
        expect(page).to_not have_content group.name
        expect(page).to have_content "所属していないグループにはアクセスできません"
      end
    end
  end
  describe 'オーナーユーザー機能' do
    before do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user[password]", with: 'adminadmin'
      click_button "ログイン"
      click_link "マイページ"
      click_link "test_group"
    end
    context 'オーナーがグループを脱退した場合' do
      it '脱退出来ずグループページに戻る' do
        find("#leave-button#{user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_content user.name
        expect(page).to have_content 'オーナーは脱退できません！'
      end
    end
    context '一般ユーザーをグループから脱退した場合' do
      it 'グループから脱退される(論理削除)' do
        find("#leave-button#{third_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{third_user.id}"
        expect(page).to have_content "#{third_user.name}さんが除名されました。"
      end
    end
    context 'オーナー権限を譲渡した場合' do
      it 'オーナー権限が渡る' do
        find("#owner-button#{second_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#owner-button#{second_user.id}"
        expect(page).to have_content "#{user.name}さんから#{second_user.name}さんに、オーナー権限を譲渡しました"
      end
    end
  end
  describe '管理者機能' do
    before do
      visit new_user_session_path
      fill_in "user_email", with: user.email
      fill_in "user[password]", with: 'adminadmin'
      click_button "ログイン"
      click_link "マイページ"
      click_link "test_group"
    end
    context 'ユーザーを完全除名した場合' do
      it 'グループから脱退される(物理削除)' do
        binding.pry
        find("#destroy-button#{third_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#destroy-button#{third_user.id}"
        expect(page).to have_content "#{third_user.name}さんが完全除名されました。"
      end
    end
  end
end
