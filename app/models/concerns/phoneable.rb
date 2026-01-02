# frozen_string_literal: true

module Phoneable
  extend ActiveSupport::Concern

  FRENCH_PHONE_REGEX = /\A0[1-9](\d{2}){4}\z/

  included do
    validates :phone, format: {with: FRENCH_PHONE_REGEX}, allow_blank: true
  end
end
