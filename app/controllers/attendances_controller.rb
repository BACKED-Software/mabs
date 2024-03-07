# frozen_string_literal: true

class AttendancesController < ApplicationController
  layout 'authenticated_layout'
  before_action :set_attendance, only: %i[show edit]
  before_action :set_user, only: %i[show edit create index]
  before_action :set_event, only: %i[show edit create]

  def delete
    @attendance = Attendance.find(params[:id])
  end

  def index
    @events = Event.all
    @attendances = Attendance.where(googleUserID: @user.uid)
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy!
    redirect_to(attendance_path, notice: 'Attendance was successfully deleted.')
  end

  def create
    if Attendance.exists?(eventID: @event.id, googleUserID: @user.uid)
      flash[:alert] = 'You have already checked in for this event'
      redirect_to attendances_path
    else
      @attendance = Attendance.new(attendance_params)
      @attendance.timeOfCheckIn = DateTime.now
      @attendance.eventID = @event.id
      @attendance.pointsAwarded = @event.eventPoints
      @attendance.googleUserID = @user.uid

      respond_to do |format|
        if @attendance.save
          format.html { redirect_to(attendances_path, notice: 'Attendance was successfully checked in.') }
          format.json { render(:show, status: :created, location: @attendance) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @attendance.errors, status: :unprocessable_entity) }
        end
      end
    end
  end

  private

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  def set_event
    @event = Event.find(params['event'])
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
