# frozen_string_literal: true

class ActivityOccurrenceGenerator
  attr_reader :activity

  def initialize(activity)
    @activity = activity
  end

  def generate
    return [activity] unless activity.recurring?
    return [] unless activity.valid?

    occurrences = [activity]
    duration = activity.ends_at - activity.starts_at
    current_start = activity.starts_at

    while (current_start = next_occurrence_date(current_start)) <= parsed_recurrence_end_date
      occurrence = build_occurrence(current_start, duration)
      occurrences << occurrence
    end

    occurrences
  end

  private

  def build_occurrence(start_time, duration)
    activity.residence.activities.build(
      title: activity.title,
      activity_type: activity.activity_type,
      description: activity.description,
      starts_at: start_time,
      ends_at: start_time + duration,
      notify_residents: activity.notify_residents
    )
  end

  def parsed_recurrence_end_date
    @parsed_recurrence_end_date ||= begin
      end_date = activity.recurrence_end_date
      end_date.is_a?(String) ? Date.parse(end_date) : end_date
    end
  end

  def next_occurrence_date(from_date)
    case activity.recurrence_frequency
    when "weekly"
      from_date + 1.week
    when "monthly"
      from_date + 1.month
    else
      from_date + 1.year # Should never happen, but prevents infinite loop
    end
  end
end
