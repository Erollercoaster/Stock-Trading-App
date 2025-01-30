class DashboardController < ApplicationController
    def index
        if current_user.admin?
          @total_traders = User.where(is_admin: false).count
          @pending_traders = User.where(pending: true).count
          @total_transactions = Transaction.count
          @recent_traders = User.where(is_admin: false).order(created_at: :desc).limit(5)
          render "admin_dashboard"
        elsif current_user.trader?
          @stocks = Stock.all.order(:symbol)
          render "trader_dashboard"
        elsif current_user.pending?
          redirect_to pending_approval_path
        else
          redirect_to new_user_session_path, alert: "Invalid user role."
        end
      end
end
