class CreateGroupings < ActiveRecord::Migration[6.1]
  def change
    create_table :groupings do |t|
      t.boolean :leave_group, index: true, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
