class UsersController < ApplicationController
    before_action :authenticate_user!, only: %i[edit update destroy]
    #before_action :set_user, only: %i[show edit update destroy]
  
    # GET /users or /users.json
    def index
      @users = User.all
    end
  
    # GET /users/1 or /users/1.json
    def show
    end
  
    # GET /users/new
    def new
      @user = User.new
    end
  
    # GET /users/1/edit
    def edit
    end
  
    # POST /users or /users.json
    def create
      @user = User.new(user_params)
  
      respond_to do |format|
        if @user.save
          format.html { redirect_to(users_path, notice: 'User was successfully created.') }
          format.json { render(:show, status: :created, location: @user) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @user.errors, status: :unprocessable_entity) }
        end
      end
    end
  
    # PATCH/PUT /users/1 or /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to(users_path, notice: 'User was successfully updated.') }
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
      @user.destroy!
      redirect_to(users_path, notice: 'User was successfully deleted.')
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
  end