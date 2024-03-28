# frozen_string_literal: true

# app/controllers/events_controller.rb
# Controller for managing event-related actions.
class EventsController < ApplicationController
  # before_action :authenticate_user!, except: %i[index show]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :set_user
  before_action :check_admin, only: %i[new create edit update delete destroy] # Custom filter to check for admin status

  layout 'authenticated_layout'

  # GET /events or /events.json
  def index
    @events = Event.all.order(eventTime: :asc)
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
  end

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to(events_path, notice: 'Event was successfully created.') }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to(events_path, notice: 'Event was successfully updated.') }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @event.errors, status: :unprocessable_entity) }
      end
    end
  end

  def delete
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy!
    flash[:notice] = 'Event was successfully deleted.'
    redirect_to events_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def check_admin
    return if current_user&.admin?

    flash[:alert] = 'You are not authorized to access this page.'
    redirect_to root_path # or any other path you wish to redirect to
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:eventLocation, :eventInfo, :eventName, :eventTime, :eventPoints, :sponsor_title,
                                  :sponsor_description, :password)
  end
end
