class UsersController < ApplicationController

  before_filter :authenticate_user!

  def account
    @user = current_user
  end

end
