class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.decimal :stock_value
      t.integer :quantity
      t.boolean :sold

      t.timestamps
    end
  end
end
