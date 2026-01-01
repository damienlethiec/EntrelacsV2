FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { "password123" }
    role { :admin }
    residence { nil }

    trait :admin do
      role { :admin }
      residence { nil }
    end

    trait :weaver do
      role { :weaver }
      residence { association :residence }
    end
  end
end
