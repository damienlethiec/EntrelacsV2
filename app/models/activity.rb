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

  belongs_to :residence

  enum :status, { planned: 0, completed: 1, canceled: 2 }
  enum :email_status, { none: 0, informed: 1, reminded: 2 }, prefix: :email

  validates :activity_type, presence: true
  validates :description, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :review, presence: true, if: :completed?
  validates :participants_count, presence: true, numericality: { greater_than: 0 }, if: :completed?
  validate :ends_at_after_starts_at

  scope :upcoming, -> { planned.where("starts_at > ?", Time.current).order(starts_at: :asc) }
  scope :past, -> { where("starts_at <= ?", Time.current).order(starts_at: :desc) }
  scope :pending_completion, -> { planned.where("starts_at <= ?", Time.current).order(starts_at: :asc) }
  scope :completed_in_period, ->(start_date, end_date) { completed.where(starts_at: start_date..end_date) }

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

  private

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?

    if ends_at <= starts_at
      errors.add(:ends_at, :after_starts_at)
    end
  end
end
