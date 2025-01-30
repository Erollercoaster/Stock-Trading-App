class Admin::TransactionsController < Admin::BaseController
    def index
      @transactions = Transaction.includes(:user, :stock).order(created_at: :desc)
      @total_bought = @transactions.bought.sum('quantity * stocks.stock_value')
      @total_sold = @transactions.sold.sum('quantity * stocks.stock_value')
    end
  end