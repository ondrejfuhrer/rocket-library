class BooksController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    connection = ActiveRecord::Base.connection
    available_letters = connection.execute('SELECT DISTINCT SUBSTR(LOWER(name), 1, 1) as letter FROM books').map { |l| l['letter'] }
    if params[:letter].present?
      name_search = { name_start: params[:letter] }
      params[:q] = params[:q].present? ? params[:q].merge(name_search) : name_search
      selected_letter = params[:letter]
    else
      selected_letter = nil
    end
    @search = Book.search params[:q]
    @books = @search.result

    links = ('a'..'z').to_a.map do |letter|
      {
        letter: letter.upcase,
        path: available_letters.include?(letter) ? alphabetic_filter_books_path(letter: letter, params: params.except(:action, :controller)) : nil,
        active: selected_letter == letter
      }
    end
    links << { letter: I18n.t('application.all'), path: books_path, active: selected_letter.nil? }

    render 'index', locals: { alphabetic_filter: links }
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

    @results = find_books 12

    respond_to do |format|
      format.js
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    # sent value for cover can be string (adding from search) or an actual file (from manual entry)
    if not params[:book][:cover].blank? and params[:book][:cover].is_a?(String)
      cover_filepath = Rails.root.join('public').join(params[:book][:cover].gsub(/^\//, ''))
      params[:book][:cover] = cover_filepath.open if File.exists?(cover_filepath)
    end
    @book.cover = params[:book][:cover] unless params[:book][:cover].blank?

    respond_to do |format|
      if params[:add_from_search].present?
        @book.save
        format.js
      else
        if @book.save
          format.html { redirect_to books_path, notice: general_added_message(@book) }
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
        format.html { redirect_to books_path, notice: general_updated_message(@book) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @book.remove
    respond_to do |format|
      format.js
      format.html { redirect_to books_url, notice: general_removed_message(@book) }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:name, :author, :sku, :isbn)
  end

  # Returns requested number of books from Google Books library
  #
  # === Parameters
  # @param [Numeric] count
  # @param [Numeric] page Default is 1
  #
  # === Return
  # @return [Array<Book>]
  #
  def find_books(count, page = 1)
    results = []

    books = GoogleBooks.search(params[:isbn], { count: count, page: page, order_by: :relevance })
    books.each do |book|
      b = Book.new
      b.name = book.title
      b.author = book.authors
      b.remote_cover_url = book.image_link
      b.isbn = book.isbn

      results << b
    end

    results.uniq { |book| book.isbn }
  end
end
