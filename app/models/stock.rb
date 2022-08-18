class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :ticker, :name, presence: true

  # Look up a stock based on the ticker symbol using the IEX Finance API and return a new instance of Stock or nil
  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key], 
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      new(
        ticker: ticker_symbol, 
        name: client.company(ticker_symbol).company_name, 
        last_price: client.price(ticker_symbol)
      )
    rescue => exception
      return nil
    end
  end

  # Check the database to know if the stock already exists or not in the table
  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

end
