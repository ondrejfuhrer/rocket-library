class RentalController < ApplicationController

  load_and_authorize_resource

  def destroy
    @rental.return
    respond_to do |format|
      format.html { redirect_to account_url, notice: 'Book was successfully returned.' }
    end
  end

end
