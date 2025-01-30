class AddPendingToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pending, :boolean, default: true, null: false
  end
end
