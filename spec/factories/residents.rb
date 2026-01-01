FactoryBot.define do
  factory :resident do
    first_name { "Jean" }
    last_name { "Dupont" }
    sequence(:email) { |n| "resident#{n}@example.com" }
    phone { "0612345678" }
    apartment { "A12" }
    residence

    trait :without_email do
      email { nil }
    end

    trait :with_notes do
      notes { "Personne âgée, apprécierait de la compagnie." }
    end
  end
end
