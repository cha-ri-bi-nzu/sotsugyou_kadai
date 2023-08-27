class CreateDesiredHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :desired_holidays do |t|
      t.date :my_holiday, index: true, null: false
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
