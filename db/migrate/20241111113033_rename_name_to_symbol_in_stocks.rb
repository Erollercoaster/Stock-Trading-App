class RenameNameToSymbolInStocks < ActiveRecord::Migration[7.1]
  def change
    rename_column :stocks, :name, :symbol
  end
end
