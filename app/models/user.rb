class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
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
  
  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
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
