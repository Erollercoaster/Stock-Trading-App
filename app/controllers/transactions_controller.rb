class TransactionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_stock, only: [:buy, :sell]
  
    def index
      @transactions = current_user.transactions.order(created_at: :desc)
    end
  
    def show
      @transaction = current_user.transactions.find(params[:id])
    end
  
    def buy
      @quantity = transaction_params[:quantity].to_i
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
            @stock.update!(available_stocks: @stock.available_stocks - @quantity)
            redirect_to @stock, notice: "Successfully purchased #{@quantity} shares of #{@stock.symbol}."
          else
            render :new, alert: "There was an error in your transaction."
          end
        end
      else
        redirect_to @stock, alert: "Insufficient balance for this purchase."
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
        sale_value = @stock.stock_value * quantity_to_sell
  
        ActiveRecord::Base.transaction do
          current_user.update!(balance: current_user.balance + sale_value)
  
          remaining_quantity = quantity_to_sell
          user_transactions.each do |transaction|
            if transaction.quantity <= remaining_quantity
              transaction.update!(sold: true)
              remaining_quantity -= transaction.quantity
            else
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
  
          @stock.update!(available_stocks: @stock.available_stocks + quantity_to_sell)
  
          redirect_to @stock, notice: "Successfully sold #{quantity_to_sell} shares of #{@stock.symbol}."
        end
      else
        redirect_to @stock, alert: "You do not have enough shares to sell."
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