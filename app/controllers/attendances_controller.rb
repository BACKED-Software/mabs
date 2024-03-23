# frozen_string_literal: true

class AttendancesController < ApplicationController
  layout 'authenticated_layout'

  before_action :set_user
  before_action :set_event, except: :index
  before_action :check_admin, only: :index

  def delete
    @attendance = Attendance.find(params[:id])
  end

  def index
    @events = Event.all
    @attendances = Attendance.all
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy!
    redirect_to(attendance_path, notice: 'Attendance was successfully deleted.')
  end

  def create
    if Attendance.exists?(eventID: @event.id, googleUserID: @user.uid)
      redirect_to(attendances_path, notice: 'You have already checked in for this event')
    elsif params[:password] == @event.password
      @attendance = Attendance.new(attendance_params)
      @attendance.timeOfCheckIn = DateTime.now
      @attendance.eventID = @event.id
      @attendance.pointsAwarded = @event.eventPoints
      @attendance.googleUserID = @user.uid

      respond_to do |format|
        if @attendance.save
          format.html { redirect_to(dashboard_index_path, notice: 'Attendance was successfully checked in.') }
          format.json { render(:show, status: :created, location: @attendance) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @attendance.errors, status: :unprocessable_entity) }
        end
      end
    else
      redirect_to(dashboard_index_path, notice: 'Incorrect Password')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  def set_event
    event_id = params[:event_id] || params[:attendance][:eventID]
    @event = Event.find(event_id)
  end

  def check_admin
    return if current_user&.admin?

    flash[:alert] = 'You are not authorized to access this page.'
    redirect_to dashboard_index_path # or any other path you wish to redirect to
  end

  def attendance_params
    params.permit(
      :eventID,
      :googleUserID,
      :timeOfCheckIn,
      :pointsAwarded
    )
  end
end
