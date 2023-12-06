require 'rails_helper'

RSpec.describe 'グループ機能', type: :system do
  describe '新規作成機能' do
    let!(:user) {FactoryBot.create(:user)}
    let!(:second_user) {FactoryBot.create(:second_user)}
    let!(:third_user) {FactoryBot.create(:third_user)}
    let!(:group) {FactoryBot.create(:group)}
    let!(:grouping) {FactoryBot.create(:grouping)}
    let!(:second_grouping) {FactoryBot.create(:second_grouping)}
    let!(:third_grouping) {FactoryBot.create(:third_grouping)}
    describe '一般ユーザー機能' do
      before do
        visit new_user_session_path
        fill_in "user_email", with: second_user.email
        fill_in "user[password]", with: 'bbbbbb'
        click_button "ログイン"
        click_link "マイページ"
      end
      context 'グループを新規作成した場合' do
        it '新規グループが作成される。' do
          click_on "グループを作る"
          fill_in "group_name", with: 'test1_group'
          click_button "登録"
          expect(page).to have_content 'test1_group'
          expect(page).to have_content 'グループ編集'
          expect(page).to have_content 'グループ削除'
          expect(page).to_not have_content 'グループ完全削除'
        end
      end
      context 'グループページに遷移した場合' do
        it 'グループに関する機能は表示されない。' do
          click_link group.name
          expect(page).to have_content 'test_group'
          expect(page).to_not have_content 'グループ編集'
          expect(page).to_not have_content 'グループ削除'
          expect(page).to_not have_content 'グループ完全削除'
        end
      end
    end
    describe 'オーナーユーザー機能' do
      before do
        visit new_user_session_path
        fill_in "user_email", with: third_user.email
        fill_in "user[password]", with: 'cccccc'
        click_button "ログイン"
        click_link "マイページ"
        click_link group.name
      end
      context 'グループを編集した場合' do
        it 'グループ名が編集される。' do
          click_on "グループ編集"
          fill_in "group_name", with: 'test2_group'
          click_button "更新"
          expect(page).to have_content 'test2_group'
        end
      end
      context 'グループ削除をした場合' do
        it 'グループが論理削除される。' do
          click_on "グループ削除"
          expect(page).to have_content 'test_groupを削除しました'
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
        click_link group.name
      end
      context 'グループを編集した場合' do
        it 'グループ名が編集される。' do
          click_on "グループ編集"
          fill_in "group_name", with: 'test2_group'
          click_button "更新"
          expect(page).to have_content 'test2_group'
        end
      end
      context 'グループ削除をした場合' do
        it 'グループが論理削除される。' do
          click_on "グループ削除"
          expect(page).to have_content 'test_groupを削除しました'
        end
      end
      context 'グループ完全削除をした場合' do
        it 'グループが完全に削除される。' do
          click_on "グループ完全削除"
          expect(page).to have_content 'test_groupを完全に削除しました'
        end
      end
    end
  end
end