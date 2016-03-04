module ApplicationHelper
  def get_flash_message_class(type)
    case type
      when 'notice'
        'alert alert-success'
      else
        'alert alert-danger'
    end
  end
end

