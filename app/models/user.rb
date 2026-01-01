class User < ApplicationRecord
  devise :invitable, :database_authenticatable,
    :recoverable, :rememberable, :validatable

  enum :role, {admin: 0, weaver: 1}

  belongs_to :residence, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :residence, presence: true, if: :weaver?

  def full_name
    "#{first_name} #{last_name}"
  end
end
