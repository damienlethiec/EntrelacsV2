class StatsController < ApplicationController
  before_action :set_date_range
  before_action :set_residence, only: :show

  def index
    authorize :stats

    @residences = Residence.active.includes(:activities).order(:name)
    @activities = Activity.completed_in_period(@start_date, @end_date)

    calculate_global_stats
    calculate_breakdowns

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv, filename: "statistiques-globales-#{Date.current}.csv" }
    end
  end

  def show
    authorize :stats

    @activities = @residence.activities.completed_in_period(@start_date, @end_date)

    calculate_residence_stats
    calculate_breakdowns

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv, filename: "statistiques-#{@residence.name.parameterize}-#{Date.current}.csv" }
    end
  end

  private

  def set_date_range
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 30.days.ago.to_date
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.current
  rescue ArgumentError
    @start_date = 30.days.ago.to_date
    @end_date = Date.current
  end

  def set_residence
    @residence = Residence.find(params[:id])
  end

  def calculate_global_stats
    @total_activities = @activities.count
    @total_participants = @activities.sum(:participants_count)
    @average_participants = @total_activities.positive? ? (@total_participants.to_f / @total_activities).round(1) : 0
    @median_participants = calculate_median(@activities.pluck(:participants_count))
    @active_residences = @activities.distinct.count(:residence_id)
    @most_popular_type = @activities.group(:activity_type).count.max_by { |_, v| v }&.first
  end

  def calculate_residence_stats
    @total_activities = @activities.count
    @total_participants = @activities.sum(:participants_count)
    @average_participants = @total_activities.positive? ? (@total_participants.to_f / @total_activities).round(1) : 0
    @median_participants = calculate_median(@activities.pluck(:participants_count))
    @most_popular_type = @activities.group(:activity_type).count.max_by { |_, v| v }&.first
  end

  def calculate_breakdowns
    @by_type = @activities.group(:activity_type).count.sort_by { |_, v| -v }
    @participants_by_type = @activities.group(:activity_type).sum(:participants_count).sort_by { |_, v| -v }
    @by_day_of_week = calculate_day_of_week_breakdown
    @participants_by_day = calculate_participants_by_day_breakdown
    @by_time_of_day = calculate_time_of_day_breakdown
    @participants_by_time = calculate_participants_by_time_breakdown
  end

  def calculate_day_of_week_breakdown
    day_names = I18n.t("date.day_names")
    counts = @activities.group_by { |a| a.starts_at.wday }.transform_values(&:count)

    (0..6).map { |day| [day_names[day], counts[day] || 0] }
  end

  def calculate_participants_by_day_breakdown
    day_names = I18n.t("date.day_names")
    participants = @activities.group_by { |a| a.starts_at.wday }.transform_values { |acts| acts.sum(&:participants_count) }

    (0..6).map { |day| [day_names[day], participants[day] || 0] }
  end

  def calculate_time_of_day_breakdown
    slots = {
      morning: (6..11),
      afternoon: (12..17),
      evening: (18..23)
    }

    result = {}
    slots.each do |slot_name, hours|
      result[I18n.t("stats.time_slots.#{slot_name}")] = @activities.count { |a| hours.include?(a.starts_at.hour) }
    end
    result
  end

  def calculate_participants_by_time_breakdown
    slots = {
      morning: (6..11),
      afternoon: (12..17),
      evening: (18..23)
    }

    result = {}
    slots.each do |slot_name, hours|
      result[I18n.t("stats.time_slots.#{slot_name}")] = @activities.select { |a| hours.include?(a.starts_at.hour) }.sum(&:participants_count)
    end
    result
  end

  def calculate_median(values)
    return 0 if values.empty?

    sorted = values.compact.sort
    mid = sorted.length / 2

    if sorted.length.odd?
      sorted[mid]
    else
      ((sorted[mid - 1] + sorted[mid]) / 2.0).round(1)
    end
  end

  def generate_csv
    require "csv"

    CSV.generate(headers: true, col_sep: ";") do |csv|
      csv << [
        I18n.t("stats.csv.residence"),
        I18n.t("stats.csv.activity_type"),
        I18n.t("stats.csv.description"),
        I18n.t("stats.csv.starts_at"),
        I18n.t("stats.csv.ends_at"),
        I18n.t("stats.csv.participants"),
        I18n.t("stats.csv.notify_residents"),
        I18n.t("stats.csv.review")
      ]

      @activities.includes(:residence).order(starts_at: :desc).each do |activity|
        csv << [
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
  end
end
