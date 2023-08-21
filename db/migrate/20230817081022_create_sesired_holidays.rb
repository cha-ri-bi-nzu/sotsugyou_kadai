class CreateSesiredHolidays < ActiveRecord::Migration[6.1]
  def change
    create_table :sesired_holidays do |t|
      t.date :my_holiday, null: false, index: true
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
