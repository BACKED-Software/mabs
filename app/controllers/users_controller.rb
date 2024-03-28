# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy make_admin delete]
  before_action :authorize_user!, only: %i[edit update destroy delete]
  before_action :authorize_admin!, only: [:make_admin]
  layout 'authenticated_layout'

  def make_admin
    @user.update!(is_admin: true)
    flash[:notice] = 'User is now an admin.'
    redirect_to @user
  end

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @rsvps = Rsvp.where(user_uid: @user.uid)
    @user = User.find(params[:id])
  end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to(dashboard_index_path, notice: 'Your profile information was successfully updated.') }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
      end
    end
  end

  # GET /users/1/delete
  def delete
    @user = User.find(params[:id])
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user = User.find(params[:id])
    # Sign out the user before deleting the account
    sign_out(current_user) if user_signed_in?
    @user.destroy!
    flash[:notice] = 'Your account has been successfully deleted.'
    redirect_to(root_path)
  end

  def update_user_title
    # Rails.logger.debug "Params: #{params.inspect}"
    @user = User.find(params[:id])
    if @user.update(user_params)
      @user.save
      # Rails.logger.debug "Update succeeded"
      flash[:notice] = "User title updated successfully."
      redirect_to admin_tools_path
    else
      # Rails.logger.debug "Update failed: #{user.errors.full_messages.join(", ")}"
      flash[:alert] = "Failed to update user title: #{user.errors.full_messages.join(", ")}"
      redirect_to admin_tools_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :is_admin, :full_name, :title, :middle_initial, :gender,
                                 :is_hispanic_or_latino, :race, :is_us_citizen,
                                 :is_first_generation_college_student, :date_of_birth,
                                 :phone_number, :avatar_url, :bio, :classification,
                                 :total_points)
  end

  # function to make sure the user is authorized to perform the action
  def authorize_user!
    return if current_user == @user || current_user.is_admin?

    flash.now[:alert] = 'You are not authorized to perform this action.'
    redirect_to(root_path)
  end

  def authorize_admin!
    return if current_user.is_admin?

    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to root_path
  end
end
