class StocksController < ApplicationController
  before_action :set_stock, only: [:show]

  def index
    if params[:symbol].present?
      @stock = Stock.find_by(symbol: params[:symbol].upcase)
      flash.now[:alert] = "Stock symbol not found. Please try another." if @stock.nil?
    end
    @stocks = Stock.all
  end

  def show
    if @stock
      if @stock.needs_update?
        api_service = AlphaVantageApi.new
        result = api_service.update_stock_price(@stock)
        
        if result[:success]
          flash.now[:notice] = "Stock value updated to $#{result[:price]}"
        else
          flash.now[:alert] = result[:error]
        end
      end
      
      @user_stock_quantity = current_user.transactions.where(stock: @stock, sold: false).sum(:quantity)
      @recent_transactions = @stock.transactions.order(created_at: :desc).limit(5)
      @transaction = Transaction.new
    end
  end

  private

  def set_stock
    @stock = Stock.find_by(symbol: params[:symbol]) || Stock.find_by(id: params[:symbol])
    redirect_to stocks_path, alert: "Stock not found." unless @stock
  end
end