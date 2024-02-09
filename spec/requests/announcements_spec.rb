require 'rails_helper'

RSpec.describe "Announcements", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/announcements/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/announcements/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/announcements/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/announcements/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/announcements/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
