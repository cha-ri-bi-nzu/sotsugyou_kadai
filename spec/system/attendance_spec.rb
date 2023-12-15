require 'rails_helper'

RSpec.describe 'シフト作成機能', type: :system do
  let!(:user){FactoryBot.create(:user)}
  let!(:second_user){FactoryBot.create(:second_user)}
  let!(:third_user){FactoryBot.create(:third_user)}
  let!(:fourth_user){FactoryBot.create(:fourth_user)}
  let!(:group){FactoryBot.create(:group)}
  let!(:grouping) {FactoryBot.create(:grouping)}
  let!(:second_grouping) {FactoryBot.create(:second_grouping)}
  let!(:third_grouping) {FactoryBot.create(:third_grouping)}
  let!(:desired_holiday) {FactoryBot.create(:desired_holiday)}
  let!(:second_desired_holiday) {FactoryBot.create(:second_desired_holiday)}
  let!(:third_desired_holiday) {FactoryBot.create(:third_desired_holiday)}
  let!(:fourth_desired_holiday) {FactoryBot.create(:fourth_desired_holiday)}
  (1..3).each do |i|
    (1..31).each do |j|
      let!(:"user#{i}_attendance#{j}") {FactoryBot.create(:"user#{i}_attendance#{j}")}
    end
  end
  describe '一般ユーザー機能' do
    before do
      visit new_user_session_path
      fill_in 'user_email', with: second_user.email
      fill_in 'user[password]', with: 'bbbbbb'
      click_button 'ログイン'
      click_link 'マイページ'
      click_link 'test_group'
    end
    context 'シフト作成ページに遷移した場合' do
      it 'そのグループページに遷移される' do
        visit new_attendance_path(group_id: group.id)
        expect(current_path).to eq group_path(group.id)
        expect(page).to have_content 'シフト作成機能はオーナーと管理者のみ使用できます'
      end
    end
    context 'シフトがある月のシフト確認ページに遷移した場合' do
      it 'その月のシフトが確認できる' do
        click_link 'シフト確認'
        select '2023', from: '[month(1i)]'
        select '8', from: '[month(2i)]'
        click_button '検索'
        expect(current_path).to eq attendances_path
        expect(page).to have_content user.name && second_user.name && third_user.name
        expect(page).to have_content '8月'
        expect(page).to_not have_content 'まだシフトがありません'
      end
    end
  end
  describe 'オーナーユーザー機能' do
    before do
      visit new_user_session_path
      fill_in 'user_email', with: third_user.email
      fill_in 'user[password]', with: 'cccccc'
      click_button 'ログイン'
      click_link 'マイページ'
      click_link 'test_group'
    end
    context 'シフトを作成した場合' do
      it 'シフトが作成され、シフト詳細ページへ遷移される' do
        click_link 'シフト確認'
        select '2023', from: '[month(1i)]'
        select '6', from: '[month(2i)]'
        click_button '検索'
        expect(page).to_not have_content user.name && second_user.name && third_user.name
        expect(page).to have_content '6月'
        expect(page).to have_content 'まだシフトがありません'
        click_link "#{group.name}に戻る"
        click_link 'シフト作成'
        select '2023', from: '[month(1i)]'
        select '6', from: '[month(2i)]'
        click_button '作成'
        expect(current_path).to eq attendance_path(Attendance.group_data(group.id).find_by(working_day: Date.parse("2023-06-01").beginning_of_month).id)
        expect(page).to have_content user.name && second_user.name && third_user.name
        expect(page).to have_content '6月'
        expect(page).to_not have_content 'まだシフトがありません'
      end
    end
    context 'シフトを作り直した場合' do
      it '新しいユーザーも含めてシフトが新規作成される' do
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{fourth_user.id}"
        click_link 'ユーザーを招待する'
        fill_in 'grouping[email]', with: fourth_user.email
        click_button '検索'
        click_link '招待する'
        click_link 'シフト確認'
        select '2023', from: '[month(1i)]'
        select '8', from: '[month(2i)]'
        click_button '検索'
        expect(current_path).to eq attendances_path
        expect(page).to have_content user.name && second_user.name && third_user.name
        expect(page).to_not have_content fourth_user.name
        expect(page).to have_content '8月'
        expect(page).to_not have_content 'まだシフトがありません'
        click_link 'シフト詳細へ'
        click_link '作り直す'
        expect(current_path).to eq attendance_path(Attendance.group_data(group.id).find_by(working_day: Date.parse("2023-08-01").beginning_of_month).id)
        expect(page).to have_content user.name && second_user.name && third_user.name && fourth_user.name
        expect(page).to have_content '8月'
        expect(page).to_not have_content 'まだシフトがありません'
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
    context 'シフトを作成した場合' do
      it 'シフトが作成され、シフト詳細ページへ遷移される' do
        click_link 'シフト確認'
        select '2023', from: '[month(1i)]'
        select '6', from: '[month(2i)]'
        click_button '検索'
        expect(page).to_not have_content user.name && second_user.name && third_user.name
        expect(page).to have_content '6月'
        expect(page).to have_content 'まだシフトがありません'
        click_link "#{group.name}に戻る"
        click_link 'シフト作成'
        select '2023', from: '[month(1i)]'
        select '6', from: '[month(2i)]'
        click_button '作成'
        expect(current_path).to eq attendance_path(Attendance.group_data(group.id).find_by(working_day: Date.parse("2023-06-01").beginning_of_month).id)
        expect(page).to have_content user.name && second_user.name && third_user.name
        expect(page).to have_content '6月'
        expect(page).to_not have_content 'まだシフトがありません'
      end
    end
    context 'シフトを作り直した場合' do
      it '新しいユーザーも含めてシフトが新規作成される' do
        expect(current_path).to eq group_path(group.id)
        expect(page).to_not have_css "#leave-button#{fourth_user.id}"
        click_link 'ユーザーを招待する'
        fill_in 'grouping[email]', with: fourth_user.email
        click_button '検索'
        click_link '招待する'
        click_link 'シフト確認'
        select '2023', from: '[month(1i)]'
        select '8', from: '[month(2i)]'
        click_button '検索'
        expect(current_path).to eq attendances_path
        expect(page).to have_content user.name && second_user.name && third_user.name
        expect(page).to_not have_content fourth_user.name
        expect(page).to have_content '8月'
        expect(page).to_not have_content 'まだシフトがありません'
        click_link 'シフト詳細へ'
        click_link '作り直す'
        expect(current_path).to eq attendance_path(Attendance.group_data(group.id).find_by(working_day: Date.parse("2023-08-01").beginning_of_month).id)
        expect(page).to have_content user.name && second_user.name && third_user.name && fourth_user.name
        expect(page).to have_content '8月'
        expect(page).to_not have_content 'まだシフトがありません'
      end
    end
  end
end
