Rails.application.config.to_prepare do
  # Define `#my_protection_method` on your ApplicationController
  Dossier::ReportsController.before_filter :authorize_reports!
end
