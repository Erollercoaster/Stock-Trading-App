class AddVolumeAndAvailableStocksToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :volume, :integer, default: 0
    add_column :stocks, :available_stocks, :integer, default: 50
  end
end
