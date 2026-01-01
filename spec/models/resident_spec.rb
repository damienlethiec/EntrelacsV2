require 'rails_helper'

RSpec.describe Resident, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:residence) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe "email format" do
      it "allows blank email" do
        resident = build(:resident, email: nil)
        expect(resident).to be_valid
      end

      it "allows valid email" do
        resident = build(:resident, email: "test@example.com")
        expect(resident).to be_valid
      end

      it "rejects invalid email" do
        resident = build(:resident, email: "invalid-email")
        expect(resident).not_to be_valid
        expect(resident.errors[:email]).to be_present
      end
    end
  end

  describe "#full_name" do
    it "returns first_name and last_name" do
      resident = build(:resident, first_name: "Jean", last_name: "Dupont")
      expect(resident.full_name).to eq("Jean Dupont")
    end
  end
end
