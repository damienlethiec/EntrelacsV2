require 'rails_helper'

RSpec.describe ResidentPolicy, type: :policy do
  subject { described_class }

  let(:admin) { create(:user, :admin) }
  let(:residence) { create(:residence) }
  let(:weaver) { create(:user, :weaver, residence: residence) }
  let(:other_weaver) { create(:user, :weaver) }
  let(:resident) { create(:resident, residence: residence) }

  permissions :index?, :show? do
    it "grants access to admin" do
      expect(subject).to permit(admin, resident)
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, resident)
    end

    it "grants access to weaver of another residence" do
      expect(subject).to permit(other_weaver, resident)
    end
  end

  permissions :create?, :new? do
    let(:new_resident) { Resident.new(residence: residence) }

    it "denies access to admin" do
      expect(subject).not_to permit(admin, new_resident)
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, new_resident)
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, new_resident)
    end
  end

  permissions :update?, :edit? do
    it "denies access to admin" do
      expect(subject).not_to permit(admin, resident)
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, resident)
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, resident)
    end
  end

  permissions :destroy? do
    it "denies access to admin" do
      expect(subject).not_to permit(admin, resident)
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, resident)
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, resident)
    end
  end

  describe "Scope" do
    let!(:resident1) { create(:resident, residence: residence) }
    let!(:resident2) { create(:resident) }

    it "returns all residents for admin" do
      scope = Pundit.policy_scope(admin, Resident)
      expect(scope).to include(resident1, resident2)
    end

    it "returns all residents for weaver" do
      scope = Pundit.policy_scope(weaver, Resident)
      expect(scope).to include(resident1, resident2)
    end
  end
end
