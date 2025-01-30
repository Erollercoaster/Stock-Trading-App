class Trader::StocksController < Trader::BaseController
  before_action :set_stock, only: [:show]

  def index
    if params[:symbol].present?
      @stock = Stock.find_by(symbol: params[:symbol].upcase)
  
      if @stock.nil?
        api_service = AlphaVantageApi.new
        api_result = api_service.time_series_intraday(params[:symbol].upcase)
  
        if api_result && api_result['Time Series (5min)']
          latest_data = api_result['Time Series (5min)'].values.first
          stock_price = latest_data['1. open'].to_f
  
          @stock = Stock.create(
            symbol: params[:symbol].upcase,
            stock_value: stock_price
          )
          flash.now[:notice] = "Stock added to the database with the latest value of $#{stock_price}."
        else
          flash.now[:alert] = "Stock symbol not found in the database or API. Please try another."
        end
      end
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