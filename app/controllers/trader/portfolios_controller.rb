class Trader::PortfoliosController < Trader::BaseController
    def show
      @holdings = current_user.transactions.bought.group(:stock_id).select('stock_id, SUM(quantity) AS total_quantity, AVG(purchase_price) AS avg_price').includes(:stock)
    end
  end