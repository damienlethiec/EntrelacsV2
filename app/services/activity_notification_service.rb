# frozen_string_literal: true

class ActivityNotificationService
  def self.send_daily_notifications
    new.send_daily_notifications
  end

  def send_daily_notifications
    total_emails_sent = 0

    Residence.includes(:residents, :users).find_each do |residence|
      new_activities = residence.activities.needing_notification.lock("FOR UPDATE SKIP LOCKED").to_a
      reminder_activities = residence.activities.needing_reminder.lock("FOR UPDATE SKIP LOCKED").to_a

      next if new_activities.empty? && reminder_activities.empty?

      emails_sent = send_notifications_to_residence(residence, new_activities, reminder_activities)
      total_emails_sent += emails_sent

      update_activity_statuses(new_activities, reminder_activities)

      log_notification_summary(residence, new_activities, reminder_activities, emails_sent)
    end

    total_emails_sent
  end

  private

  def send_notifications_to_residence(residence, new_activities, reminder_activities)
    emails_sent = 0
    residents_with_email = residence.residents.where.not(email: [nil, ""])

    residents_with_email.find_each do |resident|
      ActivityMailer.daily_notification(resident, new_activities, reminder_activities).deliver_now
      emails_sent += 1
    end

    emails_sent
  end

  def update_activity_statuses(new_activities, reminder_activities)
    Activity.transaction do
      new_activities.each(&:mark_as_informed!)
      reminder_activities.each(&:mark_as_reminded!)
    end
  end

  def log_notification_summary(residence, new_activities, reminder_activities, emails_sent)
    Rails.logger.info(
      "Activity notifications: #{residence.name} - " \
      "#{new_activities.size} new, #{reminder_activities.size} reminders, " \
      "#{emails_sent} residents notified"
    )
  end
end
