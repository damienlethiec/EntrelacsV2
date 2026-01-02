# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatsCalculator do
  let(:residence1) { create(:residence) }
  let(:residence2) { create(:residence) }

  let!(:activity1) do
    create(:activity, :completed,
      residence: residence1,
      activity_type: "Repas partagé",
      participants_count: 10,
      starts_at: Time.zone.parse("2024-01-15 10:00")) # Monday morning
  end

  let!(:activity2) do
    create(:activity, :completed,
      residence: residence1,
      activity_type: "Repas partagé",
      participants_count: 20,
      starts_at: Time.zone.parse("2024-01-16 14:00")) # Tuesday afternoon
  end

  let!(:activity3) do
    create(:activity, :completed,
      residence: residence2,
      activity_type: "Jeux de société",
      participants_count: 6,
      starts_at: Time.zone.parse("2024-01-15 19:00")) # Monday evening
  end

  let(:activities) { Activity.completed }
  let(:calculator) { described_class.new(activities) }

  describe "#total_activities" do
    it "returns the count of activities" do
      expect(calculator.total_activities).to eq(3)
    end
  end

  describe "#total_participants" do
    it "returns the sum of participants" do
      expect(calculator.total_participants).to eq(36)
    end
  end

  describe "#average_participants" do
    it "returns the average participants per activity" do
      expect(calculator.average_participants).to eq(12.0)
    end

    context "with no activities" do
      let(:activities) { Activity.none }

      it "returns 0" do
        expect(calculator.average_participants).to eq(0)
      end
    end
  end

  describe "#median_participants" do
    it "returns the median of participants" do
      # Values: [6, 10, 20] -> median is 10
      expect(calculator.median_participants).to eq(10)
    end

    context "with even number of activities" do
      let!(:activity4) do
        create(:activity, :completed, residence: residence1, participants_count: 14)
      end

      it "returns the average of the two middle values" do
        # Values: [6, 10, 14, 20] -> median is (10 + 14) / 2 = 12
        expect(calculator.median_participants).to eq(12.0)
      end
    end

    context "with no activities" do
      let(:activities) { Activity.none }

      it "returns 0" do
        expect(calculator.median_participants).to eq(0)
      end
    end
  end

  describe "#active_residences_count" do
    it "returns the count of distinct residences" do
      expect(calculator.active_residences_count).to eq(2)
    end
  end

  describe "#most_popular_type" do
    it "returns the most common activity type" do
      expect(calculator.most_popular_type).to eq("Repas partagé")
    end

    context "with no activities" do
      let(:activities) { Activity.none }

      it "returns nil" do
        expect(calculator.most_popular_type).to be_nil
      end
    end
  end

  describe "#by_type" do
    it "returns activity counts grouped by type, sorted by count desc" do
      result = calculator.by_type
      expect(result).to eq([["Repas partagé", 2], ["Jeux de société", 1]])
    end
  end

  describe "#participants_by_type" do
    it "returns participant sums grouped by type, sorted by sum desc" do
      result = calculator.participants_by_type
      expect(result).to eq([["Repas partagé", 30], ["Jeux de société", 6]])
    end
  end

  describe "#by_day_of_week" do
    it "returns activity counts for each day of the week" do
      result = calculator.by_day_of_week

      expect(result.length).to eq(7)
      expect(result[0]).to eq(["dimanche", 0])
      expect(result[1]).to eq(["lundi", 2])   # Monday: 2 activities
      expect(result[2]).to eq(["mardi", 1])   # Tuesday: 1 activity
    end
  end

  describe "#participants_by_day" do
    it "returns participant sums for each day of the week" do
      result = calculator.participants_by_day

      expect(result.length).to eq(7)
      expect(result[1]).to eq(["lundi", 16])   # Monday: 10 + 6
      expect(result[2]).to eq(["mardi", 20])   # Tuesday: 20
    end
  end

  describe "#by_time_of_day" do
    it "returns activity counts for each time slot" do
      result = calculator.by_time_of_day

      expect(result.keys).to contain_exactly(
        "Matin (6h-12h)",
        "Après-midi (12h-18h)",
        "Soir (18h-00h)"
      )
      expect(result["Matin (6h-12h)"]).to eq(1)
      expect(result["Après-midi (12h-18h)"]).to eq(1)
      expect(result["Soir (18h-00h)"]).to eq(1)
    end
  end

  describe "#participants_by_time" do
    it "returns participant sums for each time slot" do
      result = calculator.participants_by_time

      expect(result["Matin (6h-12h)"]).to eq(10)
      expect(result["Après-midi (12h-18h)"]).to eq(20)
      expect(result["Soir (18h-00h)"]).to eq(6)
    end
  end
end
