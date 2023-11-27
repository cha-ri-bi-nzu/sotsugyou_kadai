class DeleteSesiredHolidays < ActiveRecord::Migration[6.1]
  def change
    drop_table :sesired_holidays
  end
end
