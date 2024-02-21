class DashboardController < ApplicationController
  def index
    @events = Event.all
    @announcements = Announcement.all
  end
end