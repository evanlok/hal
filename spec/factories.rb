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
    vgl_header 'def header_method; end'
    vgl_content 'b.text'
  end

  factory :video do
    filename { "#{SecureRandom.uuid}.mp4" }
    duration 100
    association :videoable, factory: :video_content
    callback_url { Faker::Internet.url }
    stream_callback_url { Faker::Internet.url }
    stream_url { Faker::Internet.url }
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

  factory :scene do
    sequence(:name) { |n| "Scene #{n}" }
    active true
    vgl_content 'b.text'
  end

  factory :scene_attribute_type do
    sequence(:name) { |n| "Scene Attribute #{n}" }
  end

  factory :scene_attribute do
    scene_attribute_type
    scene
    sequence(:name) { |n| "attr_#{n}" }
    sequence(:display_name) { |n| "Attribute #{n}" }
  end

  factory :scene_collection do
    data do
      {
        font: 'http://vejeo.s3.amazonaws.com/vidgenie/fonts/lato/Lato-Bold.ttf',
        music: 'https://vejeo.s3.amazonaws.com/vidgenie/audio/music/soothing/soothing-8.mp3',
        color: '#cccccc',
        callback_url: Faker::Internet.url,
        scenes: [
          {
            scene_id: create(:scene).id,
            data: {
              city: 'San Francisco',
              state: 'Caifornia'
            },
            transition: 'SlideUp',
            transition_duration: 2.5
          }
        ]
      }
    end
  end

  factory :video_preview do
    stream_url 'http://www.onvedeo.com/stream.m3u8'
    callback_url { Faker::Internet.url }
  end
end
