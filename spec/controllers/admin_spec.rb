# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:user) { create(:user, is_admin: true) }
  let(:event) { create(:event, eventTime: Time.now + 1.day) }

  before do
    sign_in user
  end

  describe 'GET #upcoming_events' do
    it 'assigns @events' do
      get :upcoming_events
      expect(assigns(:events)).to eq([event])
    end
  end

  describe 'GET #event' do
    it 'assigns @event, @rsvps, and @rsvp_count' do
      get :event, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
      expect(assigns(:rsvps)).to eq(event.rsvps)
      expect(assigns(:rsvp_count)).to eq(event.rsvps.count)
    end
  end
end
