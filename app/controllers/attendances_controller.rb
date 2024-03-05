class AttendancesController < ApplicationController

  def edit
  end

  def delete
    
  end

  def index
    @events = Event.all
  end

  def show
    @events = Event.all
  end

  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to(attendance_path, notice: 'Attendance was successfully checked in.') }
        format.json { render(:show, status: :created, location: @attendance) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @attendance.errors, status: :unprocessable_entity) }
      end
    end
  end

  def attendance_params
    params.require(:attendance).permit(
      :eventID, 
      :googleUserID, 
      :timeOfCheckIn, 
      :pointsAwarded
    )
  end
end
