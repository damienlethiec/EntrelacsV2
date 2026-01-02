# frozen_string_literal: true

class StatsCsvExporter
  HEADERS = %w[residence activity_type description starts_at ends_at participants notify_residents review].freeze

  def initialize(activities)
    @activities = activities
  end

  def generate
    require "csv"

    CSV.generate(headers: true, col_sep: ";") do |csv|
      csv << headers
      @activities.includes(:residence).order(starts_at: :desc).each do |activity|
        csv << row_for(activity)
      end
    end
  end

  private

  def headers
    HEADERS.map { |h| I18n.t("stats.csv.#{h}") }
  end

  def row_for(activity)
    [
      activity.residence.name,
      activity.activity_type,
      activity.description,
      I18n.l(activity.starts_at, format: :short),
      activity.ends_at ? I18n.l(activity.ends_at, format: :short) : "",
      activity.participants_count,
      activity.notify_residents ? I18n.t("yes") : I18n.t("no"),
      activity.review
    ]
  end
end
