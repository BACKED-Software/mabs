require 'rails_helper'

RSpec.describe "Attendances", type: :request do
  describe "GET /edit" do
    it "returns http success" do
      get "/attendances/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/attendances/delete"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /checkin" do
    it "returns http success" do
      get "/attendances/checkin"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/attendances/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/attendances/index"
      expect(response).to have_http_status(:success)
    end
  end

end
