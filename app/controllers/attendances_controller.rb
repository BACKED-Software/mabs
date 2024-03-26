# frozen_string_literal: true

class AttendancesController < ApplicationController
  layout 'authenticated_layout'

  before_action :set_user
  before_action :set_event

  def delete
    @attendance = Attendance.find(params[:id])
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
        else
          format.html { redirect_to(dashboard_index_path, alert:  'Failed to check in') }
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

  def attendance_params
    params.permit(
      :eventID,
      :googleUserID,
      :timeOfCheckIn,
      :pointsAwarded
    )
  end
end
