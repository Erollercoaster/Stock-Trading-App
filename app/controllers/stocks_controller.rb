class StocksController < ApplicationController
  before_action :set_stock, only: [:show]

  def index
    if params[:symbol].present?
      @stock = Stock.find_by(symbol: params[:symbol].upcase)
      flash.now[:alert] = "Stock symbol not found. Please try another." if @stock.nil?
    end
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
    end
  end

  private

  def set_stock
    @stock = Stock.find_by(symbol: params[:symbol].upcase)
    redirect_to stocks_path, alert: "Stock symbol not found" if @stock.nil?
  end

end
