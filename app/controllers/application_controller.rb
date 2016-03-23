class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # All application controllers should be protected through login
  before_action :authenticate_user!

  # Creates a simple flash message for given object with a given message.
  # This function does not do any translations, so all given parameters (especially message)
  # needs to be already translated
  #
  # === Parameters
  # @param [Object] object
  # @param [String] message
  #
  def flash_error_for(object, message)
    resource_desc = object.class.model_name.human
    flash.now[:error] = "#{resource_desc} #{message.to_s.humanize(capitalize: false)}: <br />#{object.errors.full_messages.join('<br />')}".html_safe
  end

  # Creates a translated message for 'add' action for given object.
  # i.e. 'User has been successfully added'
  #
  # === Parameters
  # @param [Object] object
  #
  # === Return
  # @return [String]
  #
  def general_added_message(object)
    class_name = object.class.model_name.human
    general_message_translation class_name, 'added'
  end

  # Creates a translated message for 'update' action for given object.
  # i.e. 'User has been successfully updated'
  #
  # === Parameters
  # @param [Object] object
  #
  # === Return
  # @return [String]
  #
  def general_updated_message(object)
    class_name = object.class.model_name.human
    general_message_translation class_name, 'updated'
  end

  # Creates a translated message for 'remove' action for given object.
  # i.e. 'User has been successfully removed'
  #
  # === Parameters
  # @param [Object] object
  #
  # === Return
  # @return [String]
  #
  def general_removed_message(object)
    class_name = object.class.model_name.human
    general_message_translation class_name, 'removed'
  end

  # Authorize all actions for reporting through CanCan gem
  def authorize_reports!
    authorize! :access, :reports
  end

  private

  # Creates a translated result for general messages based on class name and type.
  # Type can be i.e. 'added', 'updated'.
  # For adding more types please make sure that a proper translation is created
  #   'application.message.general_#{type}'
  #
  # === Parameters
  # @param [String] class_name
  # @param [String] type
  #
  # === Return
  # @return [String]
  #
  def general_message_translation(class_name, type)
    I18n.t("application.message.general_#{type}", { class: class_name.humanize })
  end
end
