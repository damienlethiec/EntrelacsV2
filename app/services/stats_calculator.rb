# frozen_string_literal: true

class StatsCalculator
  attr_reader :activities

  def initialize(activities)
    @activities = activities
  end

  def total_activities
    @total_activities ||= activities.count
  end

  def total_participants
    @total_participants ||= activities.sum(:participants_count)
  end

  def average_participants
    return 0 unless total_activities.positive?
    (total_participants.to_f / total_activities).round(1)
  end

  def median_participants
    values = activities.pluck(:participants_count).compact.sort
    return 0 if values.empty?

    mid = values.length / 2
    if values.length.odd?
      values[mid]
    else
      ((values[mid - 1] + values[mid]) / 2.0).round(1)
    end
  end

  def active_residences_count
    activities.distinct.count(:residence_id)
  end

  def most_popular_type
    activities.group(:activity_type).count.max_by { |_, v| v }&.first
  end

  def by_type
    activities.group(:activity_type).count.sort_by { |_, v| -v }
  end

  def participants_by_type
    activities.group(:activity_type).sum(:participants_count).sort_by { |_, v| -v }
  end

  def by_day_of_week
    day_names = I18n.t("date.day_names")
    counts = activities.group("EXTRACT(DOW FROM starts_at)::integer").count
    (0..6).map { |day| [day_names[day], counts[day] || 0] }
  end

  def participants_by_day
    day_names = I18n.t("date.day_names")
    participants = activities.group("EXTRACT(DOW FROM starts_at)::integer").sum(:participants_count)
    (0..6).map { |day| [day_names[day], participants[day] || 0] }
  end

  def by_time_of_day
    calculate_time_breakdown(:count)
  end

  def participants_by_time
    calculate_time_breakdown(:sum)
  end

  private

  def calculate_time_breakdown(operation)
    slots = [
      {key: :morning, range: (6..11), label: I18n.t("stats.time_slots.morning")},
      {key: :afternoon, range: (12..17), label: I18n.t("stats.time_slots.afternoon")},
      {key: :evening, range: (18..23), label: I18n.t("stats.time_slots.evening")}
    ]

    slots.to_h do |config|
      hours = config[:range].to_a
      scope = activities.where("EXTRACT(HOUR FROM starts_at)::integer IN (?)", hours)
      value = (operation == :count) ? scope.count : scope.sum(:participants_count)
      [config[:label], value]
    end
  end
end
