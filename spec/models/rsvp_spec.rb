# frozen_string_literal: true

# spec/controllers/rsvps_controller_spec.rb
require 'rails_helper'

RSpec.describe RsvpsController, type: :controller do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:valid_attributes) { { user_uid: user.uid, event_id: event.id } }
  let(:invalid_attributes) { { user_uid: nil, event_id: nil } }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'assigns all rsvps as @rsvps' do
      rsvp = Rsvp.create! valid_attributes
      get :index
      expect(assigns(:rsvps)).to eq([rsvp])
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Rsvp' do
        expect do
          post :create, params: { rsvp: valid_attributes }
        end.to change(Rsvp, :count).by(1)
      end

      it 'assigns a newly created rsvp as @rsvp' do
        post :create, params: { rsvp: valid_attributes }
        expect(assigns(:rsvp)).to be_a(Rsvp)
        expect(assigns(:rsvp)).to be_persisted
      end
    end
  end
end
