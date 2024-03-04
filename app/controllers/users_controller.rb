class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy make_admin delete]
    before_action :authorize_user!, only: [:edit, :update, :destroy, :delete]
    before_action :authorize_admin!, only: [:make_admin]

    def make_admin
      @user.update!(is_admin: true)
      redirect_to @user, notice: 'User is now an admin.'
    end
  
    # GET /users or /users.json
    def index
      @users = User.all
    end
  
    # GET /users/1 or /users/1.json
    def show
      @user = User.find(params[:id])
    end
  
    # GET /users/1/edit
    def edit
    end
  
    # PATCH/PUT /users/1 or /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to(@user, notice: 'User was successfully updated.') }
          format.json { render(:show, status: :ok, location: @user) }
        else
          format.html { render(:edit, status: :unprocessable_entity) }
          format.json { render(json: @user.errors, status: :unprocessable_entity) }
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
      redirect_to(root_path, notice: 'Your account has been successfully deleted.')
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :is_admin, :full_name, :middle_initial, :gender,
                                   :is_hispanic_or_latino, :race, :is_us_citizen,
                                   :is_first_generation_college_student, :date_of_birth,
                                   :phone_number, :avatar_url, :bio, :classification,
                                   :total_points)
    end
    
    #function to make sure the user is authorized to perform the action
    def authorize_user!
      unless current_user == @user || current_user.is_admin?
        flash.now[:alert] = "You are not authorized to perform this action."
        redirect_to(users_path)
      end
    end

    def authorize_admin!
      unless current_user.is_admin?
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
    end
  end