class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :transactions, dependent: :destroy
  has_many :stocks, through: :transactions
  has_one :portfolio, dependent: :destroy

  def admin?
    is_admin
  end

  def trader?
    !is_admin
  end
end
