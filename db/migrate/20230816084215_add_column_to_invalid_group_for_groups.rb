class AddColumnToInvalidGroupForGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :invalid_group, :boolean, null: false, default: false
    add_index :groups, :invalid_group
  end
end
