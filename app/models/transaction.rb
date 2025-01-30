class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  scope :bought, -> { where(sold: false) }
  scope :sold, -> { where(sold: true) }
end
