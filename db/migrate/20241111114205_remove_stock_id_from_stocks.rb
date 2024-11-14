class RemoveStockIdFromStocks < ActiveRecord::Migration[7.1]
  def change
    remove_column :stocks, :stock_id
  end
end
