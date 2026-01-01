namespace :activities do
  desc "Send daily activity notifications to residents"
  task send_daily_notifications: :environment do
    puts "Starting daily activity notifications..."

    total_emails_sent = Activity.send_daily_notifications

    puts "Done! #{total_emails_sent} emails sent."
  end
end
