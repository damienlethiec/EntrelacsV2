require 'rails_helper'

RSpec.describe "Dashboard", type: :request do
  describe "GET /" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as admin" do
      let(:user) { create(:user, :admin) }

      before { sign_in user }

      it "redirects to stats" do
        get root_path
        expect(response).to redirect_to(stats_path)
      end
    end

    context "when authenticated as weaver" do
      let(:user) { create(:user, :weaver) }

      before { sign_in user }

      it "redirects to residence activities" do
        get root_path
        expect(response).to redirect_to(residence_activities_path(user.residence))
      end
    end
  end
end
