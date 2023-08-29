FactoryBot.define do
  factory :market do
    name { Faker::Hipster.words(number: 2).join(" ") }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    county { Faker::Hipster.word }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end
