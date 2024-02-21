class DashboardController < ApplicationController
  def index
    @events = Event.all
    @announcements = Announcement.all
    @user = current_user
  end
end