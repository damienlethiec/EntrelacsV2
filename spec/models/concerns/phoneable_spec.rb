# frozen_string_literal: true

require "rails_helper"

RSpec.describe Phoneable do
  let(:test_class) do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations
      include Phoneable

      attr_accessor :phone

      def self.model_name
        ActiveModel::Name.new(self, nil, "TestPhoneable")
      end
    end
  end

  subject(:model) { test_class.new(phone: phone) }

  describe "phone validation" do
    context "with valid French phone numbers" do
      %w[0612345678 0123456789 0987654321].each do |valid_phone|
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
        "1234567890",  # doesn't start with 0
        "06123456789", # too long
        "061234567",   # too short
        "0012345678",  # second digit is 0
        "06-12-34-56-78", # with dashes
        "06 12 34 56 78", # with spaces
        "abcdefghij"  # letters
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

  describe "FRENCH_PHONE_REGEX constant" do
    it "is accessible from the module" do
      expect(Phoneable::FRENCH_PHONE_REGEX).to eq(/\A0[1-9](\d{2}){4}\z/)
    end
  end
end
