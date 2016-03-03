class UsersController < ApplicationController

  load_and_authorize_resource

  def account
    @user = current_user
  end

end
