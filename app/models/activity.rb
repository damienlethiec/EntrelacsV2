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

  enum :status, {planned: 0, completed: 1, canceled: 2}
  enum :email_status, {none: 0, informed: 1, reminded: 2}, prefix: :email

  validates :title, presence: true
  validates :activity_type, presence: true
  validates :description, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :review, presence: true, if: :completed?
  validates :participants_count, presence: true, numericality: {greater_than: 0}, if: :completed?
  validate :ends_at_after_starts_at
  validate :recurrence_params_valid, if: :recurring?

  scope :upcoming, -> { planned.where("ends_at > ?", Time.current).order(starts_at: :asc) }
  scope :past, -> { where("ends_at <= ?", Time.current).order(starts_at: :desc) }
  scope :pending_completion, -> { planned.where("ends_at <= ?", Time.current).order(starts_at: :asc) }
  scope :completed_in_period, ->(start_date, end_date) { completed.where(starts_at: start_date..end_date) }
  scope :by_type, ->(type) { where(activity_type: type) if type.present? }
  scope :search, ->(query) {
    if query.present?
      sanitized = "%#{sanitize_sql_like(query)}%"
      where("title ILIKE ? OR description ILIKE ?", sanitized, sanitized)
    end
  }
  scope :for_calendar, ->(month) {
    start_date = month.beginning_of_month.beginning_of_week(:monday)
    end_date = month.end_of_month.end_of_week(:monday)
    where(starts_at: start_date..end_date).order(starts_at: :asc)
  }

  # Email notification scopes
  # Uses timestamps to ensure idempotency - won't re-notify if already sent today
  scope :needing_notification, -> {
    planned.where(notify_residents: true, email_status: :none)
      .where("starts_at > ?", Time.current)
      .where("email_informed_at IS NULL OR email_informed_at < ?", Time.current.beginning_of_day)
      .order(starts_at: :asc)
  }
  # Don't send reminder if notification was sent today (prevents immediate reminder after notification)
  scope :needing_reminder, -> {
    planned.where(notify_residents: true, email_status: :informed)
      .where("starts_at > ?", Time.current)
      .where("starts_at <= ?", 48.hours.from_now)
      .where("email_informed_at < ?", Time.current.beginning_of_day)
      .where("email_reminded_at IS NULL OR email_reminded_at < ?", Time.current.beginning_of_day)
      .order(starts_at: :asc)
  }

  def mark_as_informed!
    update!(email_status: :informed, email_informed_at: Time.current)
  end

  def mark_as_reminded!
    update!(email_status: :reminded, email_reminded_at: Time.current)
  end

  # Delegate to service for sending daily notifications
  def self.send_daily_notifications
    ActivityNotificationService.send_daily_notifications
  end

  def self.recent_stats(days: 30)
    recent = completed_in_period(days.days.ago, Time.current)
    {
      completed_count: recent.count,
      participants_count: recent.sum(:participants_count)
    }
  end

  def past?
    ends_at <= Time.current
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
    ActivityOccurrenceGenerator.new(self).generate
  end

  private

  def parsed_recurrence_end_date
    @parsed_recurrence_end_date ||= recurrence_end_date.is_a?(String) ? Date.parse(recurrence_end_date) : recurrence_end_date
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
      end_date = begin
        parsed_recurrence_end_date
      rescue
        nil
      end
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
