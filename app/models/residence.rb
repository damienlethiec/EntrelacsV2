class Residence < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :activities, dependent: :destroy
  # TODO: Phase 4 - has_many :residents, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  def deleted?
    deleted_at.present?
  end

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end
end
