module ApplicationHelper

  # Returns bootstrap class for flash message type
  #
  # === Parameters
  # @param [String] type
  #
  # === Return
  # @return [String]
  #
  def get_flash_message_class(type)
    case type
      when 'notice'
        'alert alert-success'
      else
        'alert alert-danger'
    end
  end

  # Returns a generated edit user link with a profile picture. This is used for overriding
  # Rails Admin original header link. Profile picture is taken from google omniauth and if
  # the picture is not present, gravatar is used
  #
  # === Return
  # @return [String]
  #
  def rails_admin_edit_user_link
    return nil unless @current_user.respond_to?(:email)
    abstract_model = RailsAdmin.config(@current_user.class).abstract_model
    return nil unless abstract_model
    return nil unless (edit_action = RailsAdmin::Config::Actions.find(:edit, controller: controller, abstract_model: abstract_model, object: @current_user)).try(:authorized?)
    get_edit_user_link @current_user, url_for(action: edit_action.action_name, model_name: abstract_model.to_param, id: @current_user.id, controller: 'rails_admin/main'.to_sym)
  end

  # Returns a generated edit user link with a profile picture.
  # Profile picture is taken from google omniauth and if the picture is not present,
  # Gravatar is used
  #
  # === Return
  # @return [String]
  #
  def header_user_link
    get_edit_user_link @current_user, dashboard_path
  end

  private

  # Generates a user link for ApplicationHelper#rails_admin_edit_user_link and ApplicationHelper#header_user_link methods
  #
  # === Parameters
  # @param [User] user
  # @param [String] link where the link will be targeted
  #
  # === Return
  # @return [String] html_safe link
  #
  def get_edit_user_link(user, link)
    link_to link do
      html = []
      if not user.google_avatar_url.blank?
        html << image_tag("#{user.google_avatar_url}?sz=30", class: 'user-avatar')
      elsif user.email.present?
        html << image_tag("#{(request.ssl? ? 'https://secure' : 'http://www')}.gravatar.com/avatar/#{Digest::MD5.hexdigest user.email}?s=30", alt: '', class: 'user-avatar')
      end

      if user.full_name.blank?
        html << content_tag(:span, user.email, class: 'user-name')
      else
        html << content_tag(:span, user.full_name, class: 'user-name')
      end
      html.join.html_safe
    end
  end
end

