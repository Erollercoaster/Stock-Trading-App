class Trader::TransactionsController < Trader::BaseController
  before_action :authenticate_user!
  before_action :set_stock, only: [:buy, :sell]

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
    @transactions_stock = current_user.transactions.includes(:stock).order(created_at: :desc)
    @total_bought = current_user.transactions.bought.sum('quantity * stock_value')
    @total_sold = current_user.transactions.sold.sum('quantity * stock_value')
  end

  def show
    @transaction = current_user.transactions.find(params[:id])
  end

  def buy
    @quantity = transaction_params[:quantity].to_i

    if @quantity <= 0
      redirect_to trader_stock_path(@stock), alert: "Please enter a valid quantity greater than 0."
      return
    end
    
    total_cost = @stock.stock_value * @quantity

    if current_user.balance >= total_cost
      @transaction = current_user.transactions.build(
        stock: @stock,
        quantity: @quantity,
        stock_value: @stock.stock_value,
        purchase_price: @stock.stock_value,
        sold: false
      )

      ActiveRecord::Base.transaction do
        if @transaction.save
          current_user.update!(balance: current_user.balance - total_cost)
          @stock.update!(
            available_stocks: @stock.available_stocks - @quantity,
            volume: @stock.volume + @quantity
          )
          redirect_to trader_stock_path(@stock), notice: "Successfully purchased #{@quantity} shares of #{@stock.symbol}."
        else
          render :new, alert: "There was an error in your transaction."
        end
      end
    else
      redirect_to trader_stock_path(@stock), alert: "Insufficient balance for this purchase."
    end
  end

  def sell
    quantity_to_sell = transaction_params[:quantity].to_i
    user_transactions = current_user.transactions.where(stock: @stock, sold: false)
    total_holdings = user_transactions.sum(:quantity)
  
    if quantity_to_sell <= 0
      redirect_to @stock, alert: "Please enter a valid quantity to sell."
      return
    end
  
    if total_holdings >= quantity_to_sell
      total_sale_value = 0
      remaining_quantity = quantity_to_sell
  
      ActiveRecord::Base.transaction do
        user_transactions.each do |transaction|
          #Whole-sale
          if transaction.quantity <= remaining_quantity
            total_sale_value += transaction.quantity * @stock.stock_value
            transaction.update!(sold: true)
            remaining_quantity -= transaction.quantity
            #Partial Sale
          else
            total_sale_value += remaining_quantity * @stock.stock_value
            transaction.update!(quantity: transaction.quantity - remaining_quantity)
  
            current_user.transactions.create!(
              stock: @stock,
              quantity: remaining_quantity,
              stock_value: @stock.stock_value,
              purchase_price: transaction.purchase_price,
              sold: true
            )
  
            remaining_quantity = 0
          end
          break if remaining_quantity == 0
        end
  
        current_user.update!(balance: current_user.balance + total_sale_value)
  
        @stock.update!(
          available_stocks: @stock.available_stocks + quantity_to_sell,
          volume: @stock.volume + quantity_to_sell
        )
  
        redirect_to trader_stock_path(@stock), notice: "Successfully sold #{quantity_to_sell} shares of #{@stock.symbol}."
      end
    else
      redirect_to trader_stock_path(@stock), alert: "You do not have enough shares to sell."
    end
  end
  

  def new
    @stock = Stock.find(params[:stock_id])
    @transaction = current_user.transactions.new(stock: @stock)
  end

  private

  def set_stock
    @stock = Stock.find(transaction_params[:stock_id])
  end

  def transaction_params
    params.require(:transaction).permit(:stock_id, :quantity)
  end
end
