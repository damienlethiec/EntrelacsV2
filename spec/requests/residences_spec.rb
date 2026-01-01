require 'rails_helper'

RSpec.describe "Residences", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver) }
  let(:residence) { create(:residence) }

  describe "GET /residences" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get residences_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get residences_path
        expect(response).to have_http_status(:success)
      end

      it "shows all active residences" do
        active = create(:residence)
        deleted = create(:residence, :deleted)

        get residences_path
        expect(response.body).to include(active.name)
        expect(response.body).not_to include(deleted.name)
      end

      it "can show deleted residences" do
        deleted = create(:residence, :deleted)

        get residences_path(show_deleted: true)
        expect(response.body).to include(deleted.name)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "returns http success" do
        get residences_path
        expect(response).to have_http_status(:success)
      end

      it "only shows own residence" do
        other_residence = create(:residence)

        get residences_path
        expect(response.body).to include(weaver.residence.name)
        expect(response.body).not_to include(other_residence.name)
      end
    end
  end

  describe "GET /residences/new" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get new_residence_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        get new_residence_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /residences" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "creates a residence with valid params" do
        expect {
          post residences_path, params: { residence: { name: "New Residence", address: "123 Street" } }
        }.to change(Residence, :count).by(1)

        expect(response).to redirect_to(residences_path)
      end

      it "renders new with invalid params" do
        post residences_path, params: { residence: { name: "", address: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        post residences_path, params: { residence: { name: "New", address: "Addr" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /residences/:id/edit" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get edit_residence_path(residence)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        get edit_residence_path(weaver.residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /residences/:id" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "updates residence with valid params" do
        patch residence_path(residence), params: { residence: { name: "Updated Name" } }
        expect(response).to redirect_to(residences_path)
        expect(residence.reload.name).to eq("Updated Name")
      end

      it "renders edit with invalid params" do
        patch residence_path(residence), params: { residence: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        patch residence_path(weaver.residence), params: { residence: { name: "Hacked" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /residences/:id" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "soft deletes the residence" do
        residence_to_delete = create(:residence)

        expect {
          delete residence_path(residence_to_delete)
        }.not_to change(Residence, :count)

        expect(residence_to_delete.reload.deleted?).to be true
        expect(response).to redirect_to(residences_path)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        delete residence_path(weaver.residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /residences/:id/restore" do
    let(:deleted_residence) { create(:residence, :deleted) }

    context "when authenticated as admin" do
      before { sign_in admin }

      it "restores the residence" do
        patch restore_residence_path(deleted_residence)
        expect(deleted_residence.reload.deleted?).to be false
        expect(response).to redirect_to(residences_path)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        patch restore_residence_path(deleted_residence)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
