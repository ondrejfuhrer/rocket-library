class RentalsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def destroy
    @rental.return
    respond_to do |format|
      format.js
      format.html { redirect_to dashboard_path, notice: 'Book was successfully returned.' }
    end
  end

  def new

  end

  def create
    sku = params[:sku]
    if sku.blank?
      redirect_to new_rental_path, alert: 'SKU cannot be blank'
    else
      book = Book.find_by_sku sku
      if not book
        redirect_to new_rental_path, alert: "Book with SKU [#{sku}] has not been found."
      else
        @rental = Rental.create book: book, user: current_user
        if not @rental.validate
          flash_error_for @rental, :cannot_be_created
          respond_to do |format|
            format.js { render 'rentals/new' }
            format.html { render 'rentals/new' }
          end
        else
          respond_to do |format|
            format.js { render 'rentals/new' }
            format.html { redirect_to dashboard_path, notice: "Book [#{book.name}] has been successfully rented" }
          end
        end
      end
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :author, :sku)
  end

end
