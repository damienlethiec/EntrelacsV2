require "rails_helper"

RSpec.describe "Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver) }
  let(:residence) { create(:residence) }

  describe "GET /admin/users" do
    context "when not authenticated" do
      it "redirects to sign in" do
        get admin_users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get admin_users_path
        expect(response).to have_http_status(:success)
      end

      it "shows all users" do
        other_admin = create(:user, :admin)
        other_weaver = create(:user, :weaver)

        get admin_users_path
        expect(response.body).to include(other_admin.full_name)
        expect(response.body).to include(other_weaver.full_name)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/users/new" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get new_admin_user_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        get new_admin_user_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /admin/users" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "invites a new admin user" do
        expect {
          post admin_users_path, params: {
            user: {
              first_name: "New",
              last_name: "Admin",
              email: "new@example.com",
              role: "admin"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(admin_users_path)
        expect(User.last.invited_to_sign_up?).to be true
      end

      it "invites a new weaver with residence" do
        expect {
          post admin_users_path, params: {
            user: {
              first_name: "New",
              last_name: "Weaver",
              email: "weaver@example.com",
              role: "weaver",
              residence_id: residence.id
            }
          }
        }.to change(User, :count).by(1)

        new_user = User.last
        expect(new_user.weaver?).to be true
        expect(new_user.residence).to eq(residence)
      end

      it "renders new with invalid params" do
        post admin_users_path, params: {user: {first_name: "", email: ""}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        post admin_users_path, params: {
          user: {first_name: "New", last_name: "User", email: "new@example.com", role: "admin"}
        }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/users/:id/edit" do
    let(:other_user) { create(:user, :weaver) }

    context "when authenticated as admin" do
      before { sign_in admin }

      it "returns http success" do
        get edit_admin_user_path(other_user)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        get edit_admin_user_path(other_user)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /admin/users/:id" do
    let(:other_user) { create(:user, :weaver) }

    context "when authenticated as admin" do
      before { sign_in admin }

      it "updates user with valid params" do
        patch admin_user_path(other_user), params: {user: {first_name: "Updated"}}
        expect(response).to redirect_to(admin_users_path)
        expect(other_user.reload.first_name).to eq("Updated")
      end

      it "can change user residence" do
        new_residence = create(:residence)
        patch admin_user_path(other_user), params: {user: {residence_id: new_residence.id}}
        expect(other_user.reload.residence).to eq(new_residence)
      end

      it "renders edit with invalid params" do
        patch admin_user_path(other_user), params: {user: {first_name: ""}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        patch admin_user_path(other_user), params: {user: {first_name: "Hacked"}}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /admin/users/:id" do
    let!(:other_user) { create(:user, :weaver) }

    context "when authenticated as admin" do
      before { sign_in admin }

      it "deletes the user" do
        expect {
          delete admin_user_path(other_user)
        }.to change(User, :count).by(-1)

        expect(response).to redirect_to(admin_users_path)
      end

      it "cannot delete themselves" do
        expect {
          delete admin_user_path(admin)
        }.not_to change(User, :count)

        expect(response).to redirect_to(root_path)
      end
    end

    context "when authenticated as weaver" do
      before { sign_in weaver }

      it "is not authorized" do
        expect {
          delete admin_user_path(other_user)
        }.not_to change(User, :count)

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
