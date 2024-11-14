class AddDefaultValuesToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :is_admin, false
    change_column_default :users, :balance, 0
    change_column_default :users, :approved, false
  end
end
