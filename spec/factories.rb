FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'test1234'

    trait :admin do
      role 'admin'
    end
  end

  factory :video_type do
    sequence(:name) { |n| "VideoType#{n}" }
  end

  factory :definition do
    video_type
    sequence(:name) { |n| "Defintion#{n}" }
    sequence(:class_name) { |n| "Defintion#{n}" }
    active true
    vgl_header 'vgl_header'
    vgl_content 'vgl_content'
  end

  factory :video do
    filename { "#{SecureRandom.uuid}.mp4" }
    duration 100
    association :videoable, factory: :find_the_best_location
  end

  factory :video_content do
    definition
    sequence(:uid) { |n| "uid-#{n}" }
    data { { attr1: 'test', attr2: 'test2' } }
  end

  factory :find_the_best_location do
    sequence(:ftb_id) { |n| n }
    definition
    county { Faker::Address.city }
    sale_price_intro 'The median sale price in'
    sale_price_verb 'has decreased'
    sale_price_change '10.50%'
    sale_price_end 'over the past year, which suggests the market has been cooling off'
    expected_intro 'Additionally, home values in the area are expected to decrease'
    expected_change '0.60%'
    expected_months 'over the next 12 months'
    list_price_intro 'The median listing price of for-sale homes is now'
    list_price_change '4.60%'
    list_price_end 'higher than it was a year ago'
    market_text 'While the typical home is on the market for about 4 fewer weeks before being sold'
  end
end
