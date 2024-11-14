class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  after_create :update_stock_volume

  private

  def update_stock_volume
    stock.increment!(:volume, quantity)
    stock.decrement!(:available_stocks, quantity)
  end

end
