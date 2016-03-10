module ApplicationHelper
  def get_flash_message_class(type)
    case type
      when 'notice'
        'alert alert-success'
      else
        'alert alert-danger'
    end
  end

  def rails_admin_google_edit_user_link
    return nil unless current_user.respond_to?(:email)
    return nil unless abstract_model = RailsAdmin.config(current_user.class).abstract_model
    return nil unless (edit_action = RailsAdmin::Config::Actions.find(:edit, controller: controller, abstract_model: abstract_model, object: current_user)).try(:authorized?)
    get_edit_user_link current_user, url_for(action: edit_action.action_name, model_name: abstract_model.to_param, id: current_user.id, controller: 'rails_admin/main')
  end

  def header_user_link
    get_edit_user_link current_user, dashboard_path
  end

  private

  def get_edit_user_link(user, link)
    link_to link do
      html = []
      if not user.google_avatar_url.blank?
        html << image_tag("#{user.google_avatar_url}?sz=30")
      elsif user.email.present?
        html << image_tag("#{(request.ssl? ? 'https://secure' : 'http://www')}.gravatar.com/avatar/#{Digest::MD5.hexdigest user.email}?s=30", alt: '')
      end

      if user.full_name.blank?
        html << content_tag(:span, user.email)
      else
        html << content_tag(:span, user.full_name)
      end
      html.join.html_safe
    end
  end
end

