class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def flash_error_for(object, message)
    resource_desc = object.class.model_name.human
    flash.now[:error] = "#{resource_desc} #{message.to_s.humanize(capitalize: false)}: <br />#{object.errors.full_messages.join('<br />')}".html_safe
  end
end
