FactoryBot.define do
  factory :residence do
    name { Faker::Company.name }
    address { Faker::Address.full_address }
    deleted_at { nil }

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
