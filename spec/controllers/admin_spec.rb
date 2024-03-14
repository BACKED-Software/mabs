# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:user) { create(:user, is_admin: true) }
  let(:event) { create(:event, eventTime: Time.now + 1.day) }

  before do
    sign_in user
  end

  describe 'GET #event' do
    it 'assigns @event, @rsvps, and @rsvp_count' do
      get :event, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
      expect(assigns(:rsvps)).to eq(event.rsvps)
      expect(assigns(:rsvp_count)).to eq(event.rsvps.count)
    end
  end

  describe "GET #admin" do
    let!(:admin) { create(:user, is_admin: true) }
    let!(:user) { create(:user, gender: 'Man', is_hispanic_or_latino: true) }

    before do
      sign_in admin
    end

    it "filters users by gender" do
      get :index, params: { gender: 'Man' }, format: :html
      expect(assigns(:users)).to include(user)
    end
    
    it "filters users by is_hispanic_or_latino" do
      get :index, params: { is_hispanic_or_latino: 'true' }, format: :html
      expect(assigns(:users)).to include(user)
    end
  end
end
