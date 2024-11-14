class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.integer :stock_id
      t.string :name
      t.decimal :stock_value

      t.timestamps
    end
  end
end
