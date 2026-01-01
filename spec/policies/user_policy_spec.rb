require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver) }
  let(:other_user) { create(:user, :admin) }

  permissions :index?, :new?, :create? do
    it "grants access to admin" do
      expect(subject).to permit(admin, User)
    end

    it "denies access to weaver" do
      expect(subject).not_to permit(weaver, User)
    end
  end

  permissions :show?, :edit?, :update?, :destroy? do
    it "grants access to admin" do
      expect(subject).to permit(admin, other_user)
    end

    it "denies access to weaver" do
      expect(subject).not_to permit(weaver, other_user)
    end

    it "denies admin destroying themselves" do
      expect(subject).not_to permit(admin, admin)
    end
  end

  describe "Scope" do
    let!(:user1) { create(:user, :admin) }
    let!(:user2) { create(:user, :weaver) }

    it "returns all users for admin" do
      scope = Pundit.policy_scope(admin, User)
      expect(scope).to include(user1, user2, admin)
    end

    it "returns empty for weaver" do
      scope = Pundit.policy_scope(weaver, User)
      expect(scope).to be_empty
    end
  end
end
