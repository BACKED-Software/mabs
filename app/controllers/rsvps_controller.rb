# frozen_string_literal: true

class RsvpsController < ApplicationController
  before_action :set_user
  before_action :set_event
  layout 'authenticated_layout'

  def create
    if @user.nil? || @event.nil?
      render json: { error: 'User or Event not found' }, status: :not_found
    elsif Rsvp.exists?(user_uid: @user.uid, event_id: @event.id)
      render json: { error: 'User has already RSVPed for this event' }, status: :unprocessable_entity
    else
      @rsvp = Rsvp.new(user_uid: @user.uid, event_id: @event.id)
      if @rsvp.save
        # render json: @rsvp, status: :created
        redirect_to root_path
      else
        render json: { errors: @rsvp.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @rsvp = Rsvp.find_by(user_uid: @user.uid, event_id: @event.id)
    @rsvp.destroy
    head :no_content
  end

  private

  def set_user
    @user = current_user
  end

  def set_event
    event_id = params[:event_id] || params[:rsvp][:event_id]
    @event = Event.find_by_id(event_id)
    render json: { error: 'Event not found' }, status: :not_found if @event.nil?
  end
end
