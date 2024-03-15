FactoryBot.define do
  factory :video do
    url { FFaker::Youtube.url }
    title { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraph }
    user
  end
end
