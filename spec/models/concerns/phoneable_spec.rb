# frozen_string_literal: true

require "rails_helper"

RSpec.describe Phoneable do
  let(:test_class) do
    Class.new(ApplicationRecord) do
      self.table_name = "residents"
      include Phoneable

      def self.model_name
        ActiveModel::Name.new(self, nil, "TestPhoneable")
      end
    end
  end

  let(:residence) { create(:residence) }
  subject(:model) { test_class.new(phone: phone, residence_id: residence.id, first_name: "Test", last_name: "User", apartment: "A1") }

  describe "phone normalization" do
    context "with French format (06...)" do
      let(:phone) { "0612345678" }

      it "normalizes to international format" do
        expect(model.phone).to eq("+33612345678")
      end
    end

    context "with spaces" do
      let(:phone) { "06 12 34 56 78" }

      it "removes spaces and normalizes" do
        expect(model.phone).to eq("+33612345678")
      end
    end

    context "with dashes" do
      let(:phone) { "06-12-34-56-78" }

      it "removes dashes and normalizes" do
        expect(model.phone).to eq("+33612345678")
      end
    end

    context "with dots" do
      let(:phone) { "06.12.34.56.78" }

      it "removes dots and normalizes" do
        expect(model.phone).to eq("+33612345678")
      end
    end

    context "already in international format" do
      let(:phone) { "+33612345678" }

      it "keeps the format" do
        expect(model.phone).to eq("+33612345678")
      end
    end

    context "with 33 prefix without +" do
      let(:phone) { "33612345678" }

      it "adds the + prefix" do
        expect(model.phone).to eq("+33612345678")
      end
    end
  end

  describe "phone validation" do
    context "with valid phone numbers" do
      %w[0612345678 0123456789 0987654321 +33612345678].each do |valid_phone|
        context "when phone is #{valid_phone}" do
          let(:phone) { valid_phone }

          it "is valid" do
            expect(model).to be_valid
          end
        end
      end
    end

    context "with invalid phone numbers" do
      [
        "1234567890",  # doesn't start with 0 or +33
        "06123456789", # too long
        "061234567",   # too short
        "0012345678",  # second digit is 0
        "abcdefghij"   # letters
      ].each do |invalid_phone|
        context "when phone is #{invalid_phone}" do
          let(:phone) { invalid_phone }

          it "is invalid" do
            expect(model).not_to be_valid
            expect(model.errors[:phone]).to be_present
          end
        end
      end
    end

    context "when phone is blank" do
      let(:phone) { "" }

      it "is valid (phone is optional)" do
        expect(model).to be_valid
      end
    end

    context "when phone is nil" do
      let(:phone) { nil }

      it "is valid (phone is optional)" do
        expect(model).to be_valid
      end
    end
  end

  describe "#phone_display" do
    context "with a stored phone" do
      let(:phone) { "+33612345678" }

      it "returns French format with spaces" do
        expect(model.phone_display).to eq("06 12 34 56 78")
      end
    end

    context "with a landline" do
      let(:phone) { "+33123456789" }

      it "returns French format with spaces" do
        expect(model.phone_display).to eq("01 23 45 67 89")
      end
    end

    context "when phone is blank" do
      let(:phone) { nil }

      it "returns nil" do
        expect(model.phone_display).to be_nil
      end
    end
  end

  describe "STORED_PHONE_REGEX constant" do
    it "is accessible from the module" do
      expect(Phoneable::STORED_PHONE_REGEX).to eq(/\A\+33[1-9]\d{8}\z/)
    end
  end
end
