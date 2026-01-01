class ActivityMailer < ApplicationMailer
  def daily_notification(resident, new_activities, reminder_activities)
    @resident = resident
    @new_activities = new_activities
    @reminder_activities = reminder_activities
    @residence = resident.residence

    weaver = @residence.users.weaver.first
    from_email = weaver&.email.presence || "contact@les-tisseurs.fr"

    mail(
      to: resident.email,
      from: from_email,
      subject: t("activity_mailer.daily_notification.subject", residence: @residence.name)
    )
  end
end
