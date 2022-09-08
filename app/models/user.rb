class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # Methods to check if the user can track a new stock

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end
  
  # Connect to the IEX Finance API, go through each of the user's stocks, and update the stock's prices
  def update_stock_prices
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key], 
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      stocks.each do |stock|
        stock.last_price = client.price(stock.ticker)
        stock.save
      end
    rescue => exception
      flash[:alert] = "The server is not responding correctly for the time being. Please try again later."
      redirect_to root_path
    end
  end

  # Method that returns the full name of a user or Anonymous if they choose not to have any name
  def full_name
    return "#{first_name} #{last_name}" if !first_name.empty? || !last_name.empty?
    "Anonymous"
  end

  # Search User/Friends methods

  def self.matches(field_name, param)
    # This returns an ActiveRecord::Relation in the console
    where("#{field_name} like ?", "%#{param}%")
  end

  def self.first_name_matches(param)
    matches("first_name", param)
  end

  def self.last_name_matches(param)
    matches("last_name", param)
  end

  def self.email_matches(param)
    matches("email", param)
  end

  def self.search(param)
    param.strip!
    # Concatenating this methods returns an array of user's objects
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    return nil unless !to_send_back.empty?
    to_send_back
  end

  # Method that runs through friends and exclude the current user if present
  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  # It checks if the id of the searched user is already in the current user's friends
  def not_friends_with?(id_of_friend)
    !self.friends.where(id: id_of_friend).exists?
  end

end
