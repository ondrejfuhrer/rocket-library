class ReportsController < ApplicationController

  before_action :authorize_reports!

  def index
    @date_from = 1.month.ago
    @date_to = Time.now
    @report = RentalReport.new
  end
end
