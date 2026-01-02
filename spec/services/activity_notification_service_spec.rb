# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActivityNotificationService do
  let(:residence) { create(:residence) }
  let!(:resident_with_email) { create(:resident, residence: residence, email: "test@example.com") }
  let!(:resident_without_email) { create(:resident, residence: residence, email: nil) }

  describe ".send_daily_notifications" do
    context "with activities needing notification" do
      let!(:activity) do
        create(:activity, :planned,
          residence: residence,
          notify_residents: true,
          starts_at: 2.days.from_now,
          ends_at: 2.days.from_now + 2.hours)
      end

      it "sends emails to residents with email addresses" do
        expect {
          described_class.send_daily_notifications
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "marks activity as informed" do
        described_class.send_daily_notifications
        expect(activity.reload.email_informed?).to be true
      end

      it "sets email_informed_at timestamp" do
        described_class.send_daily_notifications
        expect(activity.reload.email_informed_at).to be_within(1.second).of(Time.current)
      end

      it "returns the number of emails sent" do
        expect(described_class.send_daily_notifications).to eq(1)
      end
    end

    context "with activities needing reminder" do
      let!(:activity) do
        create(:activity, :planned,
          residence: residence,
          notify_residents: true,
          email_status: :informed,
          email_informed_at: 3.days.ago,
          starts_at: 1.day.from_now,
          ends_at: 1.day.from_now + 2.hours)
      end

      it "sends reminder emails" do
        expect {
          described_class.send_daily_notifications
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "marks activity as reminded" do
        described_class.send_daily_notifications
        expect(activity.reload.email_reminded?).to be true
      end
    end

    context "with no activities needing notification" do
      it "returns 0" do
        expect(described_class.send_daily_notifications).to eq(0)
      end

      it "sends no emails" do
        expect {
          described_class.send_daily_notifications
        }.not_to change { ActionMailer::Base.deliveries.count }
      end
    end

    context "with multiple residences" do
      let(:residence2) { create(:residence) }
      let!(:resident2) { create(:resident, residence: residence2, email: "test2@example.com") }

      let!(:activity1) do
        create(:activity, :planned,
          residence: residence,
          notify_residents: true,
          starts_at: 2.days.from_now,
          ends_at: 2.days.from_now + 2.hours)
      end

      let!(:activity2) do
        create(:activity, :planned,
          residence: residence2,
          notify_residents: true,
          starts_at: 2.days.from_now,
          ends_at: 2.days.from_now + 2.hours)
      end

      it "sends emails for all residences" do
        expect(described_class.send_daily_notifications).to eq(2)
      end
    end
  end
end
