require 'rails_helper'

RSpec.describe "Activities", type: :request do
  let(:residence) { create(:residence) }
  let(:other_residence) { create(:residence) }
  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver, residence: residence) }
  let(:other_weaver) { create(:user, :weaver, residence: other_residence) }

  describe "GET /residences/:residence_id/activities" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get residence_activities_path(residence)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get residence_activities_path(residence)
        expect(response).to have_http_status(:success)
      end

      it "shows upcoming activities" do
        upcoming = create(:activity, :upcoming, residence: residence)
        past = create(:activity, :past, residence: residence)

        get residence_activities_path(residence)
        expect(response.body).to include(upcoming.activity_type)
      end

      it "shows past activities when requested" do
        past = create(:activity, :past, residence: residence)

        get residence_activities_path(residence, past: true)
        expect(response.body).to include(past.activity_type)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success for own residence" do
        get residence_activities_path(residence)
        expect(response).to have_http_status(:success)
      end

      it "is not authorized for other residence" do
        get residence_activities_path(other_residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /residences/:residence_id/activities/:id" do
    let(:activity) { create(:activity, residence: residence) }

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success" do
        get residence_activity_path(residence, activity)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as other weaver" do
      before { sign_in other_weaver }

      it "is not authorized" do
        get residence_activity_path(residence, activity)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /residences/:residence_id/activities/new" do
    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success" do
        get new_residence_activity_path(residence)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as other weaver" do
      before { sign_in other_weaver }

      it "is not authorized" do
        get new_residence_activity_path(residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /residences/:residence_id/activities" do
    let(:valid_params) do
      {
        activity: {
          activity_type: "Repas partagé",
          description: "Un bon moment ensemble",
          starts_at: 1.day.from_now,
          ends_at: 1.day.from_now + 2.hours,
          notify_residents: false
        }
      }
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "creates an activity with valid params" do
        expect {
          post residence_activities_path(residence), params: valid_params
        }.to change(Activity, :count).by(1)

        expect(response).to redirect_to(residence_activities_path(residence))
      end

      it "renders new with invalid params" do
        post residence_activities_path(residence), params: { activity: { activity_type: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as other weaver" do
      before { sign_in other_weaver }

      it "is not authorized" do
        post residence_activities_path(residence), params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /residences/:residence_id/activities/:id/edit" do
    let(:activity) { create(:activity, residence: residence) }

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success" do
        get edit_residence_activity_path(residence, activity)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH /residences/:residence_id/activities/:id" do
    let(:activity) { create(:activity, residence: residence) }

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "updates activity with valid params" do
        patch residence_activity_path(residence, activity), params: { activity: { description: "Updated" } }
        expect(response).to redirect_to(residence_activities_path(residence))
        expect(activity.reload.description).to eq("Updated")
      end

      it "renders edit with invalid params" do
        patch residence_activity_path(residence, activity), params: { activity: { activity_type: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /residences/:residence_id/activities/:id/cancel" do
    let(:activity) { create(:activity, residence: residence) }

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "cancels the activity" do
        patch cancel_residence_activity_path(residence, activity)
        expect(response).to redirect_to(residence_activities_path(residence))
        expect(activity.reload).to be_canceled
      end

      it "cannot cancel a completed activity" do
        completed = create(:activity, :completed, residence: residence)
        patch cancel_residence_activity_path(residence, completed)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /residences/:residence_id/activities/:id/complete" do
    let(:activity) { create(:activity, :past, residence: residence) }

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "completes the activity" do
        patch complete_residence_activity_path(residence, activity), params: {
          review: "Super activité",
          participants_count: 10
        }
        expect(response).to redirect_to(residence_activities_path(residence))
        expect(activity.reload).to be_completed
        expect(activity.review).to eq("Super activité")
        expect(activity.participants_count).to eq(10)
      end

      it "cannot complete an upcoming activity" do
        upcoming = create(:activity, :upcoming, residence: residence)
        patch complete_residence_activity_path(residence, upcoming), params: {
          review: "Test",
          participants_count: 5
        }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
