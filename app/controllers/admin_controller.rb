class AdminController < ApplicationController
  before_action :authenticate_user!  # Ensures the user is signed in
  before_action :check_admin         # Custom filter to check for admin status
  layout "authenticated_layout"

  def index
    # Your admin dashboard code
  end

  private

  def check_admin
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path  # or any other path you wish to redirect to
    end
  end
end
