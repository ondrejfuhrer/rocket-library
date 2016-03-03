class RentalsController < ApplicationController

  load_and_authorize_resource

  def destroy
    @rental.return
    respond_to do |format|
      format.html { redirect_to authenticated_root_path, notice: 'Book was successfully returned.' }
    end
  end

  def new

  end

  def create
    sku = params[:sku]
    if sku.empty?
      redirect_to new_rental_path, alert: 'SKU cannot be blank'
    else
      book = Book.find_by_sku sku
      if not book
        redirect_to new_rental_path, alert: "Book with SKU [#{sku}] has not been found."
      else
        r = Rental.create book: book, user: current_user
        if not r.validate
          flash_error_for r, :cannot_be_created
          render 'rentals/new'
        else
          redirect_to authenticated_root_path, notice: 'Book has been successfully rented'
        end
      end
    end
  end

  private

  def book_params
    params.require(:book).permit(:name, :author, :sku)
  end

end
