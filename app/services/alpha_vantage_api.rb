require 'uri'
require 'net/http'

class AlphaVantageApi
    BASE_URL = "https://alpha-vantage.p.rapidapi.com/query".freeze

    def initialize(api_key = nil)
        @api_key = api_key || ENV["RAPIDAPI_KEY"]
    end

    def time_series_intraday(symbol)
        url = URI("#{BASE_URL}?datatype=json&output_size=compact&interval=5min&function=TIME_SERIES_INTRADAY&symbol=#{symbol}")
        make_request(url)
    end

    def update_stock_price(stock)
        data = time_series_intraday(stock.symbol)
    
        if data && data['Time Series (5min)']
          latest_data = data['Time Series (5min)'].values.first
          stock_price = latest_data['1. open'].to_f
          
          
          success = stock.update(stock_value: stock_price)
          
          if success
            { success: true, price: stock_price }
          else
            { success: false, error: "Failed to update stock record" }
          end
        else
          { success: false, error: "Failed to fetch stock price" }
        end
      rescue StandardError => e
        Rails.logger.error("Stock API Error for #{stock.symbol}: #{e.message}")
        { success: false, error: "API error occurred" }
    end

    
    private

    def make_request(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-key"] = @api_key
        request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

        response = http.request(request)
        JSON.parse(response.body)
    end

    
end