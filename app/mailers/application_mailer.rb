class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.x.mailer['default_sender']
  layout 'mailer'
end
