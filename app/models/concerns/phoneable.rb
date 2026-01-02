# frozen_string_literal: true

module Phoneable
  extend ActiveSupport::Concern

  # Format stocké en DB: +33612345678
  STORED_PHONE_REGEX = /\A\+33[1-9]\d{8}\z/

  included do
    normalizes :phone, with: ->(phone) { normalize_phone(phone) }
    validates :phone, format: {with: STORED_PHONE_REGEX}, allow_blank: true
  end

  # Affiche le téléphone en format français (06 12 34 56 78)
  def phone_display
    return nil if phone.blank?

    french = phone.sub(/\A\+33/, "0")
    french.gsub(/(\d{2})(?=\d)/, '\1 ')
  end

  class_methods do
    def normalize_phone(phone)
      return nil if phone.blank?

      # Nettoyer: enlever espaces, tirets, points
      cleaned = phone.to_s.gsub(/[\s.-]/, "")

      # Convertir format français (06...) en international (+33...)
      if cleaned.match?(/\A0[1-9]\d{8}\z/)
        "+33#{cleaned[1..]}"
      elsif cleaned.match?(/\A\+33[1-9]\d{8}\z/)
        cleaned
      elsif cleaned.match?(/\A33[1-9]\d{8}\z/)
        "+#{cleaned}"
      else
        cleaned # Laisse tel quel pour que la validation échoue
      end
    end
  end
end
