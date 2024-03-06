# frozen_string_literal: true

class PointsController < ApplicationController
  before_action :set_point, only: %i[show edit update destroy]

  def index
    @points = Point.all
  end

  def show
    redirect_to(admin)
  end

  def new
    @point = Point.new
  end

  def edit; end

  def create
    @point = Point.new(point_params)
    if @point.save
      redirect_to @point, notice: 'Point was successfully created.'
    else
      render :new
    end
  end

  def update
    if @point.update(point_params)
      redirect_to @point, notice: 'Point was successfully updated.'
    else
      render :edit
    end
  end

  def award
    user_identifier = params[:user_identifier]
    user = User.find_by(email: user_identifier)

    if user.present?
      point = user.points.build(point_params)
      if point.save
        # Redirect to a page where you want to show the flash message
        redirect_to admin_tools_path, notice: "Points successfully awarded to #{user.email}."
      else
        redirect_to admin_tools_path, alert: 'There was an error awarding points.'
      end
    else
      redirect_to admin_tools_path, alert: 'User not found.'
    end
  end

  def manage
    @user = User.find_by(email: params[:email])

    if @user
      @points = @user.points
      render partial: 'points_list', locals: { points: @points, user: @user }
    else
      render js: "alert('User not found');"
    end
  end

  def set_point; end

  def save_changes
    params[:points].each_value do |point_params|
      point = Point.find(point_params[:id])
      if point.update(point_params.permit(:id, :numPointsAwarded, :awardedBy, :dateOfAward, :awardDescription))
        # Successfully updated
      else
        # Log the error message
        Rails.logger.error "Failed to update point with ID #{point.id}: #{point.errors.full_messages.join(', ')}"
      end
    end
    redirect_to admin_tools_path, notice: 'Points were successfully updated.'
  end

  def delete
    @point = Point.find(params[:id])
  end

  def destroy
    @point = Point.find(params[:id])
    @point.destroy!
    redirect_to admin_tools_path, notice: 'Point was successfully deleted.'
  end

  private

  def point_params
    # Ensure you list all the required and permitted parameters for a point here
    params.require(:point).permit(:numPointsAwarded, :awardedBy, :awardedTo, :dateOfAward, :awardDescription)
  end
end
