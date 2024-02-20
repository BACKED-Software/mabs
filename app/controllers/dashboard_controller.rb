class DashboardController < ApplicationController
  layout "dashboard_layout"

  def index
    @events = Event.all
  end
end