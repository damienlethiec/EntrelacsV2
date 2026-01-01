class Activity < ApplicationRecord
  SUGGESTED_TYPES = [
    "Repas partagé",
    "Atelier cuisine",
    "Jeux de société",
    "Café/thé",
    "Jardinage",
    "Bricolage",
    "Sortie culturelle",
    "Sport/bien-être",
    "Échange de savoirs",
    "Réunion habitants"
  ].freeze

  RECURRENCE_FREQUENCIES = %w[weekly monthly].freeze
  MAX_RECURRENCE_DURATION = 1.year

  belongs_to :residence

  # Virtual attributes for recurring activities
  attr_accessor :recurring, :recurrence_end_date, :recurrence_frequency

  enum :status, { planned: 0, completed: 1, canceled: 2 }
  enum :email_status, { none: 0, informed: 1, reminded: 2 }, prefix: :email

  validates :activity_type, presence: true
  validates :description, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :review, presence: true, if: :completed?
  validates :participants_count, presence: true, numericality: { greater_than: 0 }, if: :completed?
  validate :ends_at_after_starts_at
  validate :recurrence_params_valid, if: :recurring?

  scope :upcoming, -> { planned.where("starts_at > ?", Time.current).order(starts_at: :asc) }
  scope :past, -> { where("starts_at <= ?", Time.current).order(starts_at: :desc) }
  scope :pending_completion, -> { planned.where("starts_at <= ?", Time.current).order(starts_at: :asc) }
  scope :completed_in_period, ->(start_date, end_date) { completed.where(starts_at: start_date..end_date) }

  # Email notification scopes
  # Uses timestamps to ensure idempotency - won't re-notify if already sent today
  scope :needing_notification, -> {
    planned.where(notify_residents: true, email_status: :none)
           .where("starts_at > ?", Time.current)
           .where("email_informed_at IS NULL OR email_informed_at < ?", Time.current.beginning_of_day)
           .order(starts_at: :asc)
  }
  scope :needing_reminder, -> {
    planned.where(notify_residents: true, email_status: :informed)
           .where("starts_at > ?", Time.current)
           .where("starts_at <= ?", 48.hours.from_now)
           .where("email_reminded_at IS NULL OR email_reminded_at < ?", Time.current.beginning_of_day)
           .order(starts_at: :asc)
  }

  def mark_as_informed!
    update!(email_status: :informed, email_informed_at: Time.current)
  end

  def mark_as_reminded!
    update!(email_status: :reminded, email_reminded_at: Time.current)
  end

  def past?
    starts_at <= Time.current
  end

  def completable?
    planned? && past?
  end

  def complete!(review:, participants_count:)
    return false unless completable?

    update(status: :completed, review: review, participants_count: participants_count)
  end

  def cancel!
    return false if completed? || canceled?

    update(status: :canceled)
  end

  def recurring?
    ActiveModel::Type::Boolean.new.cast(recurring) == true
  end

  def generate_occurrences
    return [self] unless recurring?
    return [] unless valid?

    occurrences = [self]
    duration = ends_at - starts_at
    current_start = starts_at

    while (current_start = next_occurrence_date(current_start)) <= parsed_recurrence_end_date
      occurrence = residence.activities.build(
        activity_type: activity_type,
        description: description,
        starts_at: current_start,
        ends_at: current_start + duration,
        notify_residents: notify_residents
      )
      occurrences << occurrence
    end

    occurrences
  end

  private

  def parsed_recurrence_end_date
    @parsed_recurrence_end_date ||= recurrence_end_date.is_a?(String) ? Date.parse(recurrence_end_date) : recurrence_end_date
  end

  def next_occurrence_date(from_date)
    case recurrence_frequency
    when "weekly"
      from_date + 1.week
    when "monthly"
      from_date + 1.month
    else
      from_date + 1.year # Should never happen, but prevents infinite loop
    end
  end

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?

    if ends_at <= starts_at
      errors.add(:ends_at, :after_starts_at)
    end
  end

  def recurrence_params_valid
    if recurrence_frequency.blank? || !RECURRENCE_FREQUENCIES.include?(recurrence_frequency)
      errors.add(:recurrence_frequency, :invalid)
    end

    if recurrence_end_date.blank?
      errors.add(:recurrence_end_date, :blank)
    else
      end_date = parsed_recurrence_end_date rescue nil
      if end_date.nil?
        errors.add(:recurrence_end_date, :invalid)
      elsif end_date <= starts_at.to_date
        errors.add(:recurrence_end_date, :must_be_after_start)
      elsif end_date > starts_at.to_date + MAX_RECURRENCE_DURATION
        errors.add(:recurrence_end_date, :too_far)
      end
    end
  end
end
