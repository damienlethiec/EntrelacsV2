namespace :activities do
  desc "Send daily activity notifications to residents"
  task send_daily_notifications: :environment do
    puts "Starting daily activity notifications..."

    total_emails_sent = 0

    Residence.find_each do |residence|
      new_activities = residence.activities.needing_notification.to_a
      reminder_activities = residence.activities.needing_reminder.to_a

      next if new_activities.empty? && reminder_activities.empty?

      residents_with_email = residence.residents.where.not(email: [nil, ""])

      residents_with_email.find_each do |resident|
        ActivityMailer.daily_notification(resident, new_activities, reminder_activities).deliver_now
        total_emails_sent += 1
      end

      # Update email statuses after sending to all residents
      Activity.transaction do
        new_activities.each { |activity| activity.update!(email_status: :informed) }
        reminder_activities.each { |activity| activity.update!(email_status: :reminded) }
      end

      puts "  - #{residence.name}: #{new_activities.size} new, #{reminder_activities.size} reminders, #{residents_with_email.count} residents notified"
    end

    puts "Done! #{total_emails_sent} emails sent."
  end
end
