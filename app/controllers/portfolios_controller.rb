class PortfoliosController < ApplicationController
    def show
      @holdings = current_user.transactions
                                .where(sold: false)
                                .group(:stock_id)
                                .select(
                                  'stock_id, SUM(quantity) AS total_quantity, AVG(purchase_price) AS avg_price'
                                )
                                .includes(:stock)
    end
  end