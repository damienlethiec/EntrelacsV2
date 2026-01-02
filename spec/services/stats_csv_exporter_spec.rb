# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatsCsvExporter do
  let(:residence) { create(:residence, name: "Test Residence") }
  let!(:activity) do
    create(:activity, :completed,
      residence: residence,
      title: "Dîner convivial",
      activity_type: "Repas partagé",
      description: "Un bon moment",
      starts_at: Time.zone.parse("2024-01-15 18:00"),
      ends_at: Time.zone.parse("2024-01-15 21:00"),
      participants_count: 15,
      notify_residents: true,
      review: "Super soirée")
  end

  let(:activities) { Activity.completed }
  let(:exporter) { described_class.new(activities) }

  describe "#generate" do
    subject(:csv_output) { exporter.generate }

    it "generates valid CSV" do
      expect { CSV.parse(csv_output, col_sep: ";") }.not_to raise_error
    end

    it "includes headers" do
      lines = csv_output.split("\n")
      headers = lines.first

      expect(headers).to include("Résidence")
      expect(headers).to include("Type d'activité")
      expect(headers).to include("Description")
      expect(headers).to include("Participants")
    end

    it "includes activity data" do
      expect(csv_output).to include("Test Residence")
      expect(csv_output).to include("Repas partagé")
      expect(csv_output).to include("Un bon moment")
      expect(csv_output).to include("15")
      expect(csv_output).to include("Super soirée")
    end

    it "formats dates correctly" do
      expect(csv_output).to include("15 jan.")
    end

    it "translates notify_residents boolean" do
      expect(csv_output).to include("Oui")
    end

    context "when notify_residents is false" do
      before { activity.update!(notify_residents: false) }

      it "shows Non" do
        expect(csv_output).to include("Non")
      end
    end

    context "with multiple activities" do
      let!(:activity2) do
        create(:activity, :completed,
          residence: residence,
          title: "Jeux",
          activity_type: "Jeux de société",
          participants_count: 8)
      end

      it "includes all activities" do
        expect(csv_output).to include("Repas partagé")
        expect(csv_output).to include("Jeux de société")
      end

      it "orders by starts_at desc" do
        lines = csv_output.split("\n")
        # Most recent activity should be first (after header)
        expect(lines[1]).to include("Jeux de société")
      end
    end

    context "with no activities" do
      let(:activities) { Activity.none }

      it "returns only headers" do
        lines = csv_output.split("\n")
        expect(lines.length).to eq(1)
      end
    end
  end
end
