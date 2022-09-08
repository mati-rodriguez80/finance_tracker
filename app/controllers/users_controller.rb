class UsersController < ApplicationController

  def my_portfolio
    @user = current_user
    if !current_user.stocks.empty?
      current_user.update_stock_prices
    end
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @followed_friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    if !@user.stocks.empty?
      @user.update_stock_prices
    end
    @tracked_stocks = @user.stocks
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      if !@friends.nil?
        @friends = current_user.except_current_user(@friends)
      end
      if !@friends.nil? && !@friends.empty?
        respond_to do |format|
          format.js { render partial: 'users/friend_result' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Couldn't find user"
          format.js { render partial: 'users/friend_result' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a friend name or email to search"
        format.js { render partial: 'users/friend_result' }
      end
    end
  end

end
