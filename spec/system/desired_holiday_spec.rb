require 'rails_helper'

RSpec.describe '希望休申請機能', type: :system do
  let!(:user) {FactoryBot.create(:user)}
  let!(:second_user) {FactoryBot.create(:second_user)}
  let!(:third_user) {FactoryBot.create(:third_user)}
  let!(:group) {FactoryBot.create(:group)}
  let!(:grouping) {FactoryBot.create(:grouping)}
  let!(:second_grouping) {FactoryBot.create(:second_grouping)}
  let!(:third_grouping) {FactoryBot.create(:third_grouping)}
  let!(:fourth_desired_holiday) {FactoryBot.create(:fourth_desired_holiday)}
  describe '一般ユーザー機能' do
    before do
      visit new_user_session_path
      fill_in "user_email", with: second_user.email
      fill_in "user[password]", with: 'bbbbbb'
      click_button "ログイン"
      click_link "マイページ"
      click_link group.name
    end
    context '他者の希望休の申請を行おうとした場合' do
      it 'マイページに遷移される' do
        visit new_desired_holiday_path(user_id: user.id, group_id: group.id)
        expect(current_path).to eq user_path(second_user.id)
        expect(page).to have_content '他のユーザーの希望休は申請出来ません'
        expect(page).to have_content "#{second_user.name}さんのマイページ"
        expect(page).to have_link group.name
      end
    end
    context '自身の希望休の申請をした場合' do
      it '希望休が登録され、希望休確認ページに遷移される' do
        click_link "希望休を出す"
        fill_in "desired_holiday[my_holiday]", with: '2023-12-08'
        click_button "申請"
        expect(current_path).to eq grouping_path(second_grouping.id)
        expect(page).to have_content '『2023-12-08』で希望休申請しました。'
        expect(page).to have_content "#{second_user.name}さんの#{group.name}での希望休"
        expect(page).to have_content "2023-12-08 (#{t("date.abbr_day_names")[Date.parse("2023-12-08").wday]})"
      end
    end
    context '他者の希望休ページに遷移した場合' do
      it 'マイページに遷移される' do
        visit grouping_path(grouping.id)
        expect(current_path).to eq user_path(second_user.id)
        expect(page).to have_content '他のユーザーの希望休は閲覧出来ません'
        expect(page).to have_content "#{second_user.name}さんのマイページ"
        expect(page).to have_link group.name
      end
    end
    context '自身の希望休確認ページに遷移した場合' do
      it '自身の希望休が確認できる' do
        click_link '希望休を確認する'
        expect(current_path).to eq grouping_path(second_grouping.id)
        expect(page).to have_content "#{second_user.name}さんの#{group.name}での希望休"
        expect(page).to have_content "#{fourth_desired_holiday.my_holiday} (#{t("date.abbr_day_names")[fourth_desired_holiday.my_holiday.wday]})"
        expect(page).to have_css "#destroy-button#{fourth_desired_holiday.id}"
      end
    end
    context '自身の希望休を取り消した場合' do
      it '希望休が削除される' do
        click_link '希望休を確認する'
        find("#destroy-button#{4}").click
        expect(current_path).to eq grouping_path(second_grouping.id)
        expect(page).to have_content "#{fourth_desired_holiday.my_holiday}の希望休が取り消されました"
        expect(page).to have_content "#{second_user.name}さんの#{group.name}での希望休"
        expect(page).to_not have_content "#{fourth_desired_holiday.my_holiday} (#{t("date.abbr_day_names")[fourth_desired_holiday.my_holiday.wday]})"
        expect(page).to_not have_css "#destroy-button#{fourth_desired_holiday.id}"
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
    context '他者の希望休の申請を行おうとした場合' do
      it 'そのユーザーの希望休が登録される' do
        visit new_desired_holiday_path(user_id: second_user.id, group_id: group.id)
        fill_in "desired_holiday[my_holiday]", with: '2023-12-08'
        click_button "申請"
        expect(current_path).to eq grouping_path(second_grouping.id)
        expect(page).to have_content '『2023-12-08』で希望休申請しました。'
        expect(page).to have_content "#{second_user.name}さんの#{group.name}での希望休"
        expect(page).to have_content "2023-12-08 (#{t("date.abbr_day_names")[Date.parse("2023-12-08").wday]})"
      end
    end
    context '他者の希望休ページに遷移した場合' do
      it 'そのユーザーの確認ページに遷移される' do
        visit grouping_path(second_grouping.id)
        expect(current_path).to eq grouping_path(second_grouping.id)
        expect(page).to have_content "#{second_user.name}さんの#{group.name}での希望休"
        expect(page).to have_content "#{fourth_desired_holiday.my_holiday} (#{t("date.abbr_day_names")[fourth_desired_holiday.my_holiday.wday]})"
        expect(page).to have_css "#destroy-button#{fourth_desired_holiday.id}"
      end
    end
    context '他者の希望休を取り消した場合' do
      it '希望休が削除される' do
        visit grouping_path(second_grouping.id)
        find("#destroy-button#{4}").click
        expect(current_path).to eq grouping_path(second_grouping.id)
        expect(page).to have_content "#{fourth_desired_holiday.my_holiday}の希望休が取り消されました"
        expect(page).to have_content "#{second_user.name}さんの#{group.name}での希望休"
        expect(page).to_not have_content "#{fourth_desired_holiday.my_holiday} (#{t("date.abbr_day_names")[fourth_desired_holiday.my_holiday.wday]})"
        expect(page).to_not have_css "#destroy-button#{fourth_desired_holiday.id}"
      end
    end
  end
end