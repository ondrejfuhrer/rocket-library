class UsersController < ApplicationController

  before_action :authenticate_user!

  def account
    @user = current_user
  end

end
