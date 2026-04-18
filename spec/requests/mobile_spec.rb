require "rails_helper"

RSpec.describe "MobileController", type: :request do
  describe "GET /mobile/config" do
    subject(:make_request) { get "/mobile/config" }

    context "non authentifié" do
      it "retourne un config minimal en JSON" do
        make_request

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include("application/json")

        body = JSON.parse(response.body)
        expect(body).to have_key("settings")
        expect(body).to have_key("rules")
        expect(body["tabs"]).to eq([])
      end
    end

    context "authentifié en admin" do
      let(:admin) { create(:user, :admin) }

      before { sign_in admin }

      it "retourne les 3 tabs admin" do
        make_request

        body = JSON.parse(response.body)
        tab_paths = body["tabs"].map { |t| t["path"] }
        expect(tab_paths).to eq(["/stats", "/residences", "/admin/users"])
      end

      it "contient les rules de path configuration" do
        make_request

        body = JSON.parse(response.body)
        patterns = body["rules"].flat_map { |r| r["patterns"] }
        expect(patterns).to include("/users/sign_in")
        expect(patterns).to include(".*")
      end
    end

    context "authentifié en tisseur avec résidence" do
      let(:residence) { create(:residence) }
      let(:weaver) { create(:user, :weaver, residence: residence) }

      before { sign_in weaver }

      it "retourne les 3 tabs tisseur avec residence_id injecté" do
        make_request

        body = JSON.parse(response.body)
        tab_paths = body["tabs"].map { |t| t["path"] }
        expect(tab_paths).to eq([
          "/",
          "/residences/#{residence.id}/activities",
          "/residences/#{residence.id}/residents"
        ])
      end
    end

    context "authentifié en tisseur sans résidence" do
      let(:weaver) do
        user = build(:user, :weaver, residence: nil)
        user.save(validate: false)
        user
      end

      before { sign_in weaver }

      it "ne retourne que le tab Accueil" do
        make_request

        body = JSON.parse(response.body)
        tab_paths = body["tabs"].map { |t| t["path"] }
        expect(tab_paths).to eq(["/"])
      end
    end
  end
end
