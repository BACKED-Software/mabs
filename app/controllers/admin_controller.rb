class AdminController < ApplicationController
  before_action :authenticate_user!  # Ensures the user is signed in
  before_action :check_admin         # Custom filter to check for admin status
  layout "authenticated_layout"

  def index
    @users = User.all
    @users = @users.where("email LIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def promote_to_admin
    user = User.find(params[:id])
    user.update!(is_admin: true)
    redirect_to admin_index_path, notice: "#{user.email} has been promoted to admin."
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_index_path, notice: '#{user.email} was successfully updated.'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def delete
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_index_path, notice: "#{user.email} was successfully removed."
  end

  private

  def check_admin
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path  # or any other path you wish to redirect to
    end
  end
end
