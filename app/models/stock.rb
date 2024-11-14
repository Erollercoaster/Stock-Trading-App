class Stock < ApplicationRecord
    has_many :transactions
    has_many :users, through: :transactions

    def available_quantity
        available_stocks - volume
    end

    def needs_update?
        stock_value.nil? || updated_at < 5.minutes.ago
    end
end
