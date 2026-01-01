require 'rails_helper'

RSpec.describe ResidencePolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver) }
  let(:residence) { create(:residence) }

  permissions :index? do
    it "grants access to admin" do
      expect(subject).to permit(admin, residence)
    end

    it "grants access to weaver" do
      expect(subject).to permit(weaver, residence)
    end
  end

  permissions :create?, :new? do
    it "grants access to admin" do
      expect(subject).to permit(admin, Residence)
    end

    it "denies access to weaver" do
      expect(subject).not_to permit(weaver, Residence)
    end
  end

  permissions :update?, :edit? do
    it "grants access to admin" do
      expect(subject).to permit(admin, residence)
    end

    it "denies access to weaver" do
      expect(subject).not_to permit(weaver, residence)
    end
  end

  permissions :destroy? do
    it "grants access to admin" do
      expect(subject).to permit(admin, residence)
    end

    it "denies access to weaver" do
      expect(subject).not_to permit(weaver, residence)
    end
  end

  permissions :restore? do
    it "grants access to admin" do
      expect(subject).to permit(admin, residence)
    end

    it "denies access to weaver" do
      expect(subject).not_to permit(weaver, residence)
    end
  end

  describe "Scope" do
    let!(:residence1) { create(:residence) }
    let!(:residence2) { create(:residence) }
    let!(:deleted_residence) { create(:residence, :deleted) }
    let(:weaver_with_residence) { create(:user, :weaver, residence: residence1) }

    it "returns all residences for admin" do
      scope = Pundit.policy_scope(admin, Residence)
      expect(scope).to include(residence1, residence2, deleted_residence)
    end

    it "returns all active residences for weaver" do
      scope = Pundit.policy_scope(weaver_with_residence, Residence)
      expect(scope).to include(residence1, residence2)
      expect(scope).not_to include(deleted_residence)
    end
  end
end
