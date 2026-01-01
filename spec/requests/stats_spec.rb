require "rails_helper"

RSpec.describe "Stats", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver) }
  let(:residence) { create(:residence) }
  let!(:completed_activity) do
    create(:activity, :completed, residence: residence,
           starts_at: 1.week.ago, ends_at: 1.week.ago + 2.hours,
           participants_count: 10)
  end
  let!(:another_completed) do
    create(:activity, :completed, residence: residence,
           starts_at: 2.weeks.ago, ends_at: 2.weeks.ago + 2.hours,
           participants_count: 20)
  end

  describe "GET /stats" do
    context "when logged in as admin" do
      before { sign_in admin }

      it "returns http success" do
        get stats_path
        expect(response).to have_http_status(:success)
      end

      it "displays global statistics" do
        get stats_path
        expect(response.body).to include("Statistiques globales")
        expect(response.body).to include("2") # total activities
        expect(response.body).to include("30") # total participants
      end

      it "displays residences list" do
        get stats_path
        expect(response.body).to include(residence.name)
      end

      context "with date filters" do
        it "filters by date range" do
          get stats_path, params: { start_date: 10.days.ago.to_date, end_date: Date.current }
          expect(response.body).to include("1") # only 1 activity in last 10 days
        end
      end

      context "CSV export" do
        it "exports activities as CSV" do
          get stats_path(format: :csv)
          expect(response.content_type).to include("text/csv")
          expect(response.body).to include("Type d'activité")
          expect(response.body).to include(completed_activity.activity_type)
        end
      end
    end

    context "when logged in as weaver" do
      before { sign_in weaver }

      it "redirects with not authorized" do
        get stats_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get stats_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /stats/:id" do
    context "when logged in as admin" do
      before { sign_in admin }

      it "returns http success" do
        get stat_path(residence)
        expect(response).to have_http_status(:success)
      end

      it "displays residence statistics" do
        get stat_path(residence)
        expect(response.body).to include(residence.name)
        expect(response.body).to include("2") # total activities for this residence
      end

      it "displays activity breakdown" do
        get stat_path(residence)
        expect(response.body).to include(completed_activity.activity_type)
      end

      context "with date filters" do
        it "filters by date range" do
          get stat_path(residence), params: { start_date: 10.days.ago.to_date, end_date: Date.current }
          expect(response.body).to include("1") # only 1 activity in last 10 days
        end
      end

      context "CSV export" do
        it "exports activities as CSV" do
          get stat_path(residence, format: :csv)
          expect(response.content_type).to include("text/csv")
          expect(response.body).to include(completed_activity.activity_type)
        end
      end
    end

    context "when logged in as weaver" do
      before { sign_in weaver }

      it "redirects with not authorized" do
        get stat_path(residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
