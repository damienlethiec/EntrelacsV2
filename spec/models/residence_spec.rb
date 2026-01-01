require "rails_helper"

RSpec.describe Residence, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
  end

  describe "associations" do
    it { should have_many(:users).dependent(:nullify) }
    # TODO: Phase 2 - it { should have_many(:residents).dependent(:destroy) }
    # TODO: Phase 3 - it { should have_many(:activities).dependent(:destroy) }
  end

  describe "scopes" do
    let!(:active_residence) { create(:residence) }
    let!(:deleted_residence) { create(:residence, :deleted) }

    describe ".active" do
      it "returns only active residences" do
        expect(Residence.active).to contain_exactly(active_residence)
      end
    end

    describe ".deleted" do
      it "returns only deleted residences" do
        expect(Residence.deleted).to contain_exactly(deleted_residence)
      end
    end
  end

  describe "#deleted?" do
    it "returns true when deleted_at is present" do
      residence = build(:residence, :deleted)
      expect(residence.deleted?).to be true
    end

    it "returns false when deleted_at is nil" do
      residence = build(:residence)
      expect(residence.deleted?).to be false
    end
  end

  describe "#soft_delete" do
    it "sets deleted_at to current time" do
      residence = create(:residence)
      expect { residence.soft_delete }.to change { residence.deleted_at }.from(nil)
    end
  end

  describe "#restore" do
    it "sets deleted_at to nil" do
      residence = create(:residence, :deleted)
      expect { residence.restore }.to change { residence.deleted_at }.to(nil)
    end
  end
end
