require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }

    context "when weaver" do
      subject { build(:user, :weaver, residence: nil) }
      it { should validate_presence_of(:residence) }
    end

    context "when admin" do
      subject { build(:user, :admin) }
      it { should_not validate_presence_of(:residence) }
    end
  end

  describe "associations" do
    it { should belong_to(:residence).optional }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(admin: 0, weaver: 1) }
  end

  describe "#full_name" do
    it "returns the full name" do
      user = build(:user, first_name: "Jean", last_name: "Dupont")
      expect(user.full_name).to eq("Jean Dupont")
    end
  end
end
