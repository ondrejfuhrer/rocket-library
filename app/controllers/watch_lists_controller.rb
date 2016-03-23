class WatchListsController < ApplicationController

  load_and_authorize_resource

  def create
    unless WatchList.find_by(rental_id: params[:rental_id], user: current_user)
      @watch_list = WatchList.create rental_id: params[:rental_id], user: current_user
    end

    respond_to do |format|
      format.js
    end
  end
end
