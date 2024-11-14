class AddPurchasePriceToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :purchase_price, :decimal, precision: 10, scale: 2
  end
end
