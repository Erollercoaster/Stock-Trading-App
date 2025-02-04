# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require_relative '../app/services/alpha_vantage_api' # Ensure the correct path

# Initialize API client
api_client = AlphaVantageApi.new

# Seed demo accounts for testing
admin_email = 'admin_demo@example.com'
client_email = 'client_demo@example.com'

admin = User.find_or_create_by!(email: admin_email) do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.is_admin = true
  user.approved = true  # Ensuring the admin is approved
  user.confirmed_at = Time.now # Simulating email confirmation
  user.balance = 10_000.00 # Giving admin some funds
  user.pending = false # Marking the account as processed
end

client = User.find_or_create_by!(email: client_email) do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.is_admin = false
  user.approved = true # Ensuring the client is approved
  user.confirmed_at = Time.now
  user.balance = 5_000.00 # Giving client initial funds for trading
  user.pending = false
end

puts "Admin demo account: #{admin_email} / password123"
puts "Client demo account: #{client_email} / password123"

# Seed stocks dynamically from API
stock_symbols = ["AAPL", "TSLA", "GOOGL", "AMZN"] # Define required stocks

stock_symbols.each do |symbol|
  stock = Stock.find_or_create_by!(symbol: symbol) do |s|
    s.stock_value = 0.00 # Placeholder, will be updated dynamically
    s.volume = rand(500..1000)
    s.available_stocks = rand(50..200)
  end

  # Fetch and update stock price
  api_response = api_client.update_stock_price(stock)
  if api_response[:success]
    puts "Stock seeded: #{stock.symbol} - Updated Price: $#{api_response[:price]}"
  else
    puts "Failed to fetch stock price for #{stock.symbol}: #{api_response[:error]}"
  end
end

# Ensure client has a portfolio
client_portfolio = Portfolio.find_or_create_by!(user: client)

# Simulate transactions for the client
if client.transactions.empty?
  stock = Stock.first # Assigning the first available stock
  client.transactions.create!(
    stock: stock,
    stock_value: stock.stock_value,
    quantity: 5,
    sold: false,
    purchase_price: stock.stock_value
  )
  puts "Transaction created: Client bought 5 shares of #{stock.symbol} at $#{stock.stock_value}"
end

puts "Seeding completed successfully!"

