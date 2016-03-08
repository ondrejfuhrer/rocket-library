class BooksController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @books = Book.all
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @book.remove
    respond_to do |format|
      format.js
      format.html { redirect_to books_url, notice: 'Book was successfully removed.' }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:name, :author, :sku)
  end
end
