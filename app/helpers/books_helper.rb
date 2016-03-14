module BooksHelper

  # Returns a bootstrap class for given book state
  #
  # === Parameters
  # @param [String] state
  #
  def get_bootstrap_class_for_state(state)
    case state
      when 'active'
        'label label-success'
      when 'rented'
        'label label-danger'
      else
        ''
    end
  end
end
