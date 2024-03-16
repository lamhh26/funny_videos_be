FactoryBot.define do
  factory :video do
    url { FFaker::Youtube.url }
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    user

    trait :skip_callbacks do
      before(:create) { |video| video.define_singleton_method(:change_info) {} }
    end
  end
end
