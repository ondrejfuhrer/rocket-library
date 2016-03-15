class UserMailer < ApplicationMailer

  # Sends a watchlist email about given book to given user
  #
  # === Parameters
  # @param [User] user
  # @param [Rental] rental
  #
  def watchlist(user, rental)
    @user = user
    @rental = rental

    mail to: user.email, subject: default_i18n_subject(book_name: rental.book.name)
  end
end