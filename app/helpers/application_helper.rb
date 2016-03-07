module ApplicationHelper
  def get_flash_message_class(type)
    case type
      when 'notice'
        'alert alert-success'
      else
        'alert alert-danger'
    end
  end

  def google_edit_user_link
    return nil unless current_user.respond_to?(:email)
    return nil unless abstract_model = RailsAdmin.config(current_user.class).abstract_model
    return nil unless (edit_action = RailsAdmin::Config::Actions.find(:edit, controller: controller, abstract_model: abstract_model, object: current_user)).try(:authorized?)
    link_to url_for(action: edit_action.action_name, model_name: abstract_model.to_param, id: _current_user.id, controller: 'rails_admin/main') do
      html = []
      html << image_tag("#{current_user.google_avatar_url}?sz=30")
      html << content_tag(:span, current_user.email)
      html.join.html_safe
    end
  end
end

