FactoryBot.define do
  factory :activity do
    activity_type { Activity::SUGGESTED_TYPES.sample }
    description { "Description de l'activité" }
    starts_at { 1.day.from_now }
    ends_at { 1.day.from_now + 2.hours }
    notify_residents { false }
    residence

    trait :upcoming do
      starts_at { 1.week.from_now }
      ends_at { 1.week.from_now + 2.hours }
    end

    trait :past do
      starts_at { 1.week.ago }
      ends_at { 1.week.ago + 2.hours }
    end

    trait :completed do
      past
      status { :completed }
      review { "Très bonne activité avec beaucoup de participation." }
      participants_count { rand(5..20) }
    end

    trait :canceled do
      status { :canceled }
    end

    trait :with_notification do
      notify_residents { true }
    end

    trait :informed do
      with_notification
      email_status { :informed }
    end

    trait :reminded do
      with_notification
      email_status { :reminded }
    end
  end
end
