class Trader::BaseController < ApplicationController
    before_action :ensure_trader

    private

    def ensure_trader
        redirect_to root_path, alert: "Access denied." unless current_user.trader?
    end
end