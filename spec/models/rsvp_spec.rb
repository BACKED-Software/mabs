# frozen_string_literal: true

# spec/controllers/rsvps_controller_spec.rb
require 'rails_helper'

RSpec.describe RsvpsController, type: :controller do
  let!(:user) { create(:admin) }
  let!(:event) { create(:event) }
  let(:user2) { create(:user) }
  let(:valid_attributes) { { user_uid: user.uid, event_id: event.id } }
  let(:invalid_attributes) { { user_uid: nil, event_id: nil } }

  before do
    sign_in user
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

    context 'when user or event is not found' do
      it 'returns a not found error' do
        allow(controller).to receive(:current_user).and_return(nil)
        post :create, params: { rsvp: { user_uid: user.uid, event_id: event.id } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'User or Event not found' })
      end
    end

    context 'when user has already RSVPed for this event' do
      it 'returns an unprocessable entity error' do
        allow(controller).to receive(:current_user).and_return(user)
        Rsvp.create(user_uid: user.uid, event_id: event.id) # create an existing RSVP
        post :create, params: { rsvp: { user_uid: user.uid, event_id: event.id } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'User has already RSVPed for this event' })
      end
    end

    context 'when RSVP cannot be saved' do
      it 'returns an unprocessable entity error' do
        allow(controller).to receive(:current_user).and_return(user)
        allow_any_instance_of(Rsvp).to receive(:save).and_return(false)
        post :create, params: { rsvp: { user_uid: user.uid, event_id: event.id } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end

    context 'when event is not found' do
      it 'returns a not found error' do
        allow(controller).to receive(:current_user).and_return(user)
        post :create, params: { rsvp: { user_uid: user.uid, event_id: 'non-existent-id' } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Event not found' })
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:rsvp) { create(:rsvp, user_uid: user.uid, event_id: event.id) } # replace with your RSVP creation logic

    it 'deletes the RSVP' do
      expect do
        delete :destroy, params: { id: rsvp.id }
      end.to change(Rsvp, :count).by(-1)
    end
  end
end
