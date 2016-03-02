class RentalController < ApplicationController

  before_filter :authenticate_user!
  before_action :set_rental, only: [:destroy]

  def destroy
    @rental.return
    respond_to do |format|
      format.html { redirect_to account_url, notice: 'Book was successfully returned.' }
    end
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

end
