# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActivityOccurrenceGenerator do
  let(:residence) { create(:residence) }
  let(:activity) do
    build(:activity,
      residence: residence,
      title: "Repas hebdomadaire",
      activity_type: "Repas partagé",
      description: "Un moment convivial",
      starts_at: Time.zone.parse("2024-01-15 18:00"),
      ends_at: Time.zone.parse("2024-01-15 21:00"),
      notify_residents: true)
  end

  describe "#generate" do
    context "when activity is not recurring" do
      before { activity.recurring = false }

      it "returns array with only the original activity" do
        result = described_class.new(activity).generate
        expect(result).to eq([activity])
      end
    end

    context "when activity is invalid" do
      before do
        activity.recurring = true
        activity.recurrence_frequency = "weekly"
        activity.recurrence_end_date = 1.month.from_now.to_date
        activity.title = nil # Make invalid
      end

      it "returns empty array" do
        result = described_class.new(activity).generate
        expect(result).to be_empty
      end
    end

    context "when activity is recurring weekly" do
      before do
        activity.recurring = true
        activity.recurrence_frequency = "weekly"
        activity.recurrence_end_date = "2024-02-06" # End date must be after last occurrence time
      end

      it "generates the correct number of occurrences" do
        result = described_class.new(activity).generate
        expect(result.length).to eq(4) # Original + 3 weekly occurrences
      end

      it "includes the original activity" do
        result = described_class.new(activity).generate
        expect(result.first).to eq(activity)
      end

      it "creates occurrences with correct dates" do
        result = described_class.new(activity).generate

        expect(result[1].starts_at).to eq(Time.zone.parse("2024-01-22 18:00"))
        expect(result[2].starts_at).to eq(Time.zone.parse("2024-01-29 18:00"))
        expect(result[3].starts_at).to eq(Time.zone.parse("2024-02-05 18:00"))
      end

      it "preserves duration for occurrences" do
        result = described_class.new(activity).generate
        original_duration = activity.ends_at - activity.starts_at

        result[1..].each do |occurrence|
          expect(occurrence.ends_at - occurrence.starts_at).to eq(original_duration)
        end
      end

      it "copies activity attributes to occurrences" do
        result = described_class.new(activity).generate

        result[1..].each do |occurrence|
          expect(occurrence.title).to eq("Repas hebdomadaire")
          expect(occurrence.activity_type).to eq("Repas partagé")
          expect(occurrence.description).to eq("Un moment convivial")
          expect(occurrence.notify_residents).to be true
          expect(occurrence.residence).to eq(residence)
        end
      end
    end

    context "when activity is recurring monthly" do
      before do
        activity.recurring = true
        activity.recurrence_frequency = "monthly"
        activity.recurrence_end_date = "2024-04-16" # End date must be after last occurrence time
      end

      it "generates monthly occurrences" do
        result = described_class.new(activity).generate
        expect(result.length).to eq(4) # Original + 3 monthly

        expect(result[1].starts_at).to eq(Time.zone.parse("2024-02-15 18:00"))
        expect(result[2].starts_at).to eq(Time.zone.parse("2024-03-15 18:00"))
        expect(result[3].starts_at).to eq(Time.zone.parse("2024-04-15 18:00"))
      end
    end

    context "with recurrence_end_date as Date object" do
      before do
        activity.recurring = true
        activity.recurrence_frequency = "weekly"
        activity.recurrence_end_date = Date.parse("2024-01-30") # End date must be after last occurrence time
      end

      it "handles Date object correctly" do
        result = described_class.new(activity).generate
        expect(result.length).to eq(3) # Original + 2 weekly
      end
    end
  end
end
