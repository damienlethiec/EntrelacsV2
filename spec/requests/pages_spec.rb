require "rails_helper"

RSpec.describe "PagesController", type: :request do
  describe "GET /privacy" do
    subject(:make_request) { get "/privacy" }

    context "non authentifié" do
      it "retourne 200 et le contenu de la privacy policy" do
        make_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Politique de confidentialité")
        expect(response.body).to include("Les Tisseurs")
        expect(response.body).to include("Marie Lerivrain")
        expect(response.body).to include("m.lerivrain@les-tisseurs.fr")
      end
    end

    context "authentifié" do
      let(:user) { create(:user, :admin) }

      before { sign_in user }

      it "retourne aussi 200 (page publique)" do
        make_request

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
