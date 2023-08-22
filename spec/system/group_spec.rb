require 'rails_helper'

RSpec.describe 'グループ機能', type: :system do
  describe '新規作成機能' do
    let!(:user) {FactoryBot.create(:user)}
    let!(:group) {FactoryBot.create(:group, owner_id: user.id)}
    let!(:grouping) {FactoryBot.create(:grouping, user_id: user.id, group_id: group.id)}
    context 'グループを新規作成した場合' do
      it '新規グループが作成される。' do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user[password]", with: 'adminadmin'
        click_button "ログイン"
        click_on "グループを作る"
        fill_in "group_name", with: 'test1_group'
        click_button "登録"
        expect(page).to have_content 'test1_group'
      end
    end
    context 'グループを編集した場合' do
      it 'グループ名が編集される。' do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user[password]", with: 'adminadmin'
        click_button "ログイン"
        click_on "test_group"
        click_on "グループ編集"
        fill_in "group_name", with: 'test2_group'
        click_button "更新"
        expect(page).to have_content 'test2_group'
      end
    end
    context 'グループ削除をした場合' do
      it 'グループが論理削除される。' do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user[password]", with: 'adminadmin'
        click_button "ログイン"
        click_on "test_group"
        click_on "グループ削除"
        expect(page).to have_content 'test_groupを削除しました'
      end
    end
    context 'グループ完全削除をした場合' do
      it 'グループが完全に削除される。' do
        visit new_user_session_path
        fill_in "user_email", with: user.email
        fill_in "user[password]", with: 'adminadmin'
        click_button "ログイン"
        click_on "test_group"
        click_on "グループ完全削除"
        expect(page).to have_content 'test_groupを完全に削除しました'
      end
    end
  end
end