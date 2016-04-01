class UserMailer < ApplicationMailer

  # Sends a watchlist email about given book to given user
  #
  # === Parameters
  # @param [User] user
  # @param [Rental] rental
  #
  # === Return
  # @return [Mail::Message]
  #
  def watchlist(user, rental)
    @user = user
    @rental = rental

    mail to: user.email, subject: default_i18n_subject(book_name: rental.book.name)
  end

  # Sends an email, that someone else was faster then me when renting book in my watchlist
  #
  # === Parameters
  # @param [User] user
  # @param [Rental] rental
  #
  # === Return
  # @return [Mail::Message]
  #
  def watchlist_unfulfilled(user, rental)
    @user = user
    @rental = rental

    mail to: user.email, subject: default_i18n_subject(book_name: rental.book.name)
  end
end
