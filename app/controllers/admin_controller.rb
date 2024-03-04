class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @users = User.all
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_index_path, notice: 'User was successfully updated.'
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_index_path, notice: 'User was successfully removed.'
  end

  private

  def verify_admin
    redirect_to(root_path, alert: 'Not authorized') unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:role)
  end
end
