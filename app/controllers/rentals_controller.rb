class RentalsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def destroy
    @rental.return_message = params[:return_message] if params[:return_message].present?
    @rental.return
    respond_to do |format|
      format.js
      format.html { redirect_to dashboard_path, notice: I18n.t('rental.message.destroy') }
    end
  end

  def new

  end

  def create
    sku = params[:sku]
    if sku.blank?
      redirect_to new_rental_path, alert: I18n.t('rental.error.blank_sku')
    else
      book = Book.find_by_sku sku
      if not book
        redirect_to new_rental_path, alert: I18n.t('rental.error.invalid_sku', { sku: sku })
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
            format.html { redirect_to dashboard_path, notice: I18n.t('rental.message.successfully_rented', { name: book.name }) }
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
