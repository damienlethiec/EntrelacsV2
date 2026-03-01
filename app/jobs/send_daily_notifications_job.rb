# frozen_string_literal: true

class SendDailyNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    ActivityNotificationService.send_daily_notifications
  end
end
