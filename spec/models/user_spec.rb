# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, is_admin: true) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    before do
      sign_in user
    end
    it 'returns a success response' do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    before do
      sign_in user
    end
    context 'with valid parameters' do
      it 'updates the user' do
        patch :update, params: { id: user.id, user: { full_name: 'New Name' } }
        user.reload
        expect(user.full_name).to eq('New Name')
      end

      it 'redirects to the users path' do
        patch :update, params: { id: user.id, user: { full_name: 'New Name' } }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        patch :update, params: { id: user.id, user: { email: nil } }
        user.reload
        expect(user.email).not_to be_nil
      end

      it 'renders the edit template' do
        patch :update, params: { id: user.id, user: { email: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #delete' do
    before do
      sign_in user
    end
    it 'returns a success response' do
      get :delete, params: { id: user.id }
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in user
    end
    it 'destroys the user' do
      delete :destroy, params: { id: user.id }
      expect(User.exists?(user.id)).to be_falsey
    end

    it 'redirects to the root path' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'PATCH #make_admin' do
    context 'when user is an admin' do
      before do
        sign_in admin
      end

      it 'makes the user an admin' do
        patch :make_admin, params: { id: user.id }
        user.reload
        expect(user.is_admin).to be_truthy
      end

      it 'redirects to the user path' do
        patch :make_admin, params: { id: user.id }
        expect(response).to redirect_to(user_path(user))
      end
    end

    context 'when user is not an admin' do
      before do
        sign_in user
      end
      it 'does not make the user an admin' do
        patch :make_admin, params: { id: user.id }
        user.reload
        expect(user.is_admin).to be_falsey
      end

      it 'redirects to the root path' do
        patch :make_admin, params: { id: user.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
