# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendDailyNotificationsJob, type: :job do
  it "delegates to ActivityNotificationService.send_daily_notifications" do
    allow(ActivityNotificationService).to receive(:send_daily_notifications)

    described_class.perform_now

    expect(ActivityNotificationService).to have_received(:send_daily_notifications)
  end

  it "uses the default queue" do
    expect(described_class.new.queue_name).to eq("default")
  end
end
