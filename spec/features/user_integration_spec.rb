require 'rails_helper'

RSpec.describe "Users", type: :request do
    let!(:user) { create(:user) } # Assumes you have a User factory
    let(:admin) { create(:user, is_admin: true) }
  
    describe "GET /users/:id" do
      it "displays the user" do
        get user_path(user)
        expect(response).to have_http_status(200)
        expect(response.body).to include(user.full_name)
        expect(response.body).to include(user.email)
      end
    end

    describe "GET /users" do
      it "displays all users" do
        get users_path
        expect(response).to have_http_status(200)
        expect(response.body).to include(user.full_name)
        expect(response.body).to include(user_path(user)) 
      end
    end

    describe "GET /users/:id/edit" do
      before do
        sign_in user
      end
      it "displays the edit form" do
        get edit_user_path(user)
        expect(response).to have_http_status(200)
        expect(response.body).to include('Update Profile')
        expect(response.body).to include('Back to Dashboard')
      end
    end
    
    describe "PATCH /users/:id" do
      before do
        sign_in user
      end
      let(:params) do
        {
          user: {
            full_name: "New Name",
            gender: "Man",
            is_hispanic_or_latino: true,
            race: "Asian",
            is_us_citizen: true,
            is_first_generation_college_student: false,
            date_of_birth: "2000-01-01T00:00",
            phone_number: "1234567890",
            bio: "New Bio",
            classification: "U1"
          }
        }
      end

      it "updates the user and redirects to the show page" do
        patch user_path(user), params: params
        expect(response).to redirect_to(user_path(user))
        follow_redirect!
        expect(response.body).to include('New Name')
        expect(response.body).to include('Man')
        expect(response.body).to include('Yes') # for is_hispanic_or_latino and is_us_citizen
        expect(response.body).to include('No')  # for is_first_generation_college_student
        expect(response.body).to include('Asian')
        expect(response.body).to include('2000-01-01')
        expect(response.body).to include('1234567890')
        expect(response.body).to include('New Bio')
        expect(response.body).to include('U1')
      end
    end
end