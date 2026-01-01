require 'rails_helper'

RSpec.describe "Residents", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:residence) { create(:residence) }
  let(:weaver) { create(:user, :weaver, residence: residence) }
  let(:other_weaver) { create(:user, :weaver) }
  let(:resident) { create(:resident, residence: residence) }

  describe "GET /residences/:residence_id/residents" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get residence_residents_path(residence)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get residence_residents_path(residence)
        expect(response).to have_http_status(:success)
      end

      it "shows all residents" do
        resident1 = create(:resident, residence: residence, first_name: "Marie", last_name: "Martin")
        resident2 = create(:resident, residence: residence, first_name: "Pierre", last_name: "Leroy")

        get residence_residents_path(residence)
        expect(response.body).to include(resident1.full_name)
        expect(response.body).to include(resident2.full_name)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success" do
        get residence_residents_path(residence)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver of another residence" do
      before { sign_in other_weaver }

      it "returns http success (can view all residences)" do
        get residence_residents_path(residence)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /residences/:residence_id/residents/:id" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get residence_resident_path(residence, resident)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success" do
        get residence_resident_path(residence, resident)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /residences/:residence_id/residents/new" do
    context "when authenticated as weaver of the residence" do
      before { sign_in weaver }

      it "returns http success" do
        get new_residence_resident_path(residence)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver of another residence" do
      before { sign_in other_weaver }

      it "is not authorized" do
        get new_residence_resident_path(residence)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "is not authorized" do
        get new_residence_resident_path(residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /residences/:residence_id/residents" do
    let(:valid_params) { { resident: { first_name: "Marie", last_name: "Martin", email: "marie@example.com", apartment: "B3" } } }

    context "when authenticated as weaver of the residence" do
      before { sign_in weaver }

      it "creates a resident with valid params" do
        expect {
          post residence_residents_path(residence), params: valid_params
        }.to change(Resident, :count).by(1)

        expect(response).to redirect_to(residence_residents_path(residence))
      end

      it "renders new with invalid params" do
        post residence_residents_path(residence), params: { resident: { first_name: "", last_name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as weaver of another residence" do
      before { sign_in other_weaver }

      it "is not authorized" do
        post residence_residents_path(residence), params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "is not authorized" do
        post residence_residents_path(residence), params: valid_params
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /residences/:residence_id/residents/:id/edit" do
    context "when authenticated as weaver of the residence" do
      before { sign_in weaver }

      it "returns http success" do
        get edit_residence_resident_path(residence, resident)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver of another residence" do
      before { sign_in other_weaver }

      it "is not authorized" do
        get edit_residence_resident_path(residence, resident)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "is not authorized" do
        get edit_residence_resident_path(residence, resident)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /residences/:residence_id/residents/:id" do
    context "when authenticated as weaver of the residence" do
      before { sign_in weaver }

      it "updates resident with valid params" do
        patch residence_resident_path(residence, resident), params: { resident: { first_name: "Updated" } }
        expect(response).to redirect_to(residence_residents_path(residence))
        expect(resident.reload.first_name).to eq("Updated")
      end

      it "renders edit with invalid params" do
        patch residence_resident_path(residence, resident), params: { resident: { first_name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as weaver of another residence" do
      before { sign_in other_weaver }

      it "is not authorized" do
        patch residence_resident_path(residence, resident), params: { resident: { first_name: "Hacked" } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "is not authorized" do
        patch residence_resident_path(residence, resident), params: { resident: { first_name: "Hacked" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /residences/:residence_id/residents/:id" do
    context "when authenticated as weaver of the residence" do
      before { sign_in weaver }

      it "deletes the resident" do
        resident_to_delete = create(:resident, residence: residence)

        expect {
          delete residence_resident_path(residence, resident_to_delete)
        }.to change(Resident, :count).by(-1)

        expect(response).to redirect_to(residence_residents_path(residence))
      end
    end

    context "when authenticated as weaver of another residence" do
      before { sign_in other_weaver }

      it "is not authorized" do
        delete residence_resident_path(residence, resident)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "is not authorized" do
        delete residence_resident_path(residence, resident)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
