class AddCascadeToTransactionsUserId < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :transactions, :users
    add_foreign_key :transactions, :users, on_delete: :cascade
    remove_foreign_key :transactions, :stocks
    add_foreign_key :transactions, :stocks, on_delete: :cascade
  end
end
