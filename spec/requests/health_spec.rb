# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Health check", type: :request do
  describe "GET /up" do
    it "returns healthy status" do
      get "/up"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("healthy")
      expect(json["database"]).to be true
    end

    it "does not require authentication" do
      get "/up"
      expect(response).to have_http_status(:ok)
    end

    it "includes timestamp and version" do
      get "/up"
      json = JSON.parse(response.body)
      expect(json["timestamp"]).to be_present
      expect(json["version"]).to be_present
    end
  end
end
