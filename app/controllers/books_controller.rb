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

  def search
    @book = Book.new
    @results = []

    books = GoogleBooks.search(params[:isbn], {count: 10})
    books.each do |book|
      b = Book.new
      b.name = book.title
      b.author = book.authors
      b.remote_cover_url = book.image_link
      b.isbn = book.isbn

      @results << b
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    # sent value for cover can be string (adding from search) or an actual file (from manual entry)
    params[:book][:cover] = Rails.root.join('public').join(params[:book][:cover].gsub(/^\//, '')).open if not params[:book][:cover].blank? and params[:book][:cover].is_a?(String)
    @book.cover = params[:book][:cover] unless params[:book][:cover].blank?

    respond_to do |format|
      if params[:add_from_search].present?
        @book.save
        format.js
      else
        if @book.save
          format.html { redirect_to @book, notice: 'Book was successfully added.' }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    respond_to do |format|
      params_to_update = book_params
      params_to_update[:cover] = params[:book][:cover] unless params[:book][:cover].blank?
      if @book.update(params_to_update)
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
    params.require(:book).permit(:name, :author, :sku, :isbn)
  end
end
