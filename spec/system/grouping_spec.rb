require 'rails_helper'

RSpec.describe 'グルーピング機能', type: :system do
  let!(:user){FactoryBot.create(:user)}
  let!(:second_user){FactoryBot.create(:second_user)}
  let!(:third_user){FactoryBot.create(:third_user)}
  let!(:fourth_user){FactoryBot.create(:fourth_user)}
  let!(:group){FactoryBot.create(:group)}
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
      click_link "test_group"
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
      fill_in "user_email", with: third_user.email
      fill_in "user[password]", with: 'cccccc'
      click_button "ログイン"
      click_link "マイページ"
      click_link "test_group"
    end
    context '既に加入しているユーザーをグループに招待した場合' do
      it 'ユーザーを招待できない' do
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: user.email
        click_button "検索"
        expect(current_path).to eq groupings_path
        expect(page).to have_content user.name
        expect(page).to have_content "このユーザーは既に#{group.name}に所属しています"
      end
    end
    context 'ユーザーをグループに招待した場合' do
      it 'ユーザーがグループに加入される' do
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{fourth_user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: fourth_user.email
        click_button "検索"
        click_link "招待する"
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{fourth_user.id}"
        expect(page).to have_content "#{fourth_user.name}さんが参加されました。"
      end
    end
    context 'オーナーがグループを脱退した場合' do
      it '脱退出来ずグループページに戻る' do
        find("#leave-button#{third_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_content user.name
        expect(page).to have_content 'オーナーは脱退できません！'
      end
    end
    context '一般ユーザーをグループから脱退した場合' do
      it 'グループから脱退される(論理削除)' do
        find("#leave-button#{user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{user.id}"
        expect(page).to have_content "#{user.name}さんが除名されました。"
      end
    end
    context '脱退したユーザーをグループに招待した場合' do
      it 'ユーザーがグループに再加入される' do
        find("#leave-button#{user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: user.email
        click_button "検索"
        click_link "招待する"
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{user.id}"
        expect(page).to have_content "#{user.name}さんが再招待されました。"
      end
    end
    context 'オーナー権限を譲渡した場合' do
      it 'オーナー権限が渡る' do
        find("#owner-button#{second_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#owner-button#{second_user.id}"
        expect(page).to have_content "#{third_user.name}さんから#{second_user.name}さんに、オーナー権限を譲渡しました"
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
    context '既に加入しているユーザーをグループに招待した場合' do
      it 'ユーザーを招待できない' do
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: user.email
        click_button "検索"
        expect(current_path).to eq groupings_path
        expect(page).to have_content user.name
        expect(page).to have_content "このユーザーは既に#{group.name}に所属しています"
      end
    end
    context 'ユーザーをグループに招待した場合' do
      it 'ユーザーがグループに加入される' do
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{fourth_user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: fourth_user.email
        click_button "検索"
        click_link "招待する"
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{fourth_user.id}"
        expect(page).to have_content "#{fourth_user.name}さんが参加されました。"
      end
    end
    context 'オーナーをグループを脱退した場合' do
      it '脱退出来ずグループページに戻る' do
        find("#leave-button#{third_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_content user.name
        expect(page).to have_content 'オーナーは脱退できません！'
      end
    end
    context '一般ユーザーをグループから脱退した場合' do
      it 'グループから脱退される(論理削除)' do
        find("#leave-button#{user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{user.id}"
        expect(page).to have_content "#{user.name}さんが除名されました。"
      end
    end
    context '脱退したユーザーをグループに招待した場合' do
      it 'ユーザーがグループに再加入される' do
        find("#leave-button#{user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: user.email
        click_button "検索"
        click_link "招待する"
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{user.id}"
        expect(page).to have_content "#{user.name}さんが再招待されました。"
      end
    end
    context 'オーナー権限を譲渡した場合' do
      it 'オーナー権限が渡る' do
        find("#owner-button#{second_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#owner-button#{second_user.id}"
        expect(page).to have_content "#{third_user.name}さんから#{second_user.name}さんに、オーナー権限を譲渡しました"
      end
    end
    context 'ユーザーを完全除名した場合' do
      it 'グループから脱退される(物理削除)' do
        # binding.pry
        find("#destroy-button#{third_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#destroy-button#{third_user.id}"
        expect(page).to have_content "#{third_user.name}さんが完全に除名されました。"
      end
    end
    context '完全除名したユーザーをグループに招待した場合' do
      it 'ユーザーが初参加としてグループに加入される' do
        find("#destroy-button#{third_user.id}").click
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{third_user.id}"
        click_link "ユーザーを招待する"
        fill_in "grouping[email]", with: third_user.email
        click_button "検索"
        click_link "招待する"
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_css "#leave-button#{third_user.id}"
        expect(page).to have_content "#{third_user.name}さんが参加されました。"
      end
    end
  end
end
