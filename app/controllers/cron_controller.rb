class CronController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_cron_token!

  def send_notifications
    # Appeler la même logique que la rake task
    Activity.send_daily_notifications

    render json: {status: "ok", sent_at: Time.current}
  end

  private

  def authenticate_cron_token!
    expected_token = ENV["CRON_SECRET_TOKEN"]
    provided_token = request.headers["Authorization"]&.remove("Bearer ")

    unless expected_token.present? && ActiveSupport::SecurityUtils.secure_compare(expected_token, provided_token.to_s)
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
  end
end
