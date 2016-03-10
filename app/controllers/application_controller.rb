class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def flash_error_for(object, message)
    resource_desc = object.class.model_name.human
    flash.now[:error] = "#{resource_desc} #{message.to_s.humanize(capitalize: false)}: <br />#{object.errors.full_messages.join('<br />')}".html_safe
  end

  def general_added_message(object)
    class_name = object.class.model_name.human
    general_message_translation class_name, 'added'
  end

  def general_updated_message(object)
    class_name = object.class.model_name.human
    general_message_translation class_name, 'updated'
  end

  def general_removed_message(object)
    class_name = object.class.model_name.human
    general_message_translation class_name, 'removed'
  end

  private

  def general_message_translation(class_name, type)
    I18n.t("application.message.general_#{type}", { class: class_name.humanize })
  end
end
