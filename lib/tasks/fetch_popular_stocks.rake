namespace :stocks do
    desc "Populate stocks table with a predefined list of popular symbols"
    task populate_popular: :environment do
      api = AlphaVantageApi.new
      symbols = ["AAPL", "MSFT", "GOOG", "TSLA", "AMZN", "META"]
  
      symbols.each do |symbol|
        data = api.time_series_intraday(symbol)
        puts "Data for #{symbol}: #{data.inspect}"
        next unless data && data['Time Series (5min)']
  
        first_open_value = data['Time Series (5min)'].values.first['1. open'] rescue nil
        next unless first_open_value
  
        stock_info = {
          symbol: symbol,
          stock_value: first_open_value.to_f
        }
  
        Stock.find_or_create_by(symbol: stock_info[:symbol]) do |stock|
          stock.update(stock_info)
        end
        puts "Added/Updated stock: #{symbol}"
      end
    end
  end
  