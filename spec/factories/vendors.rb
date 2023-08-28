FactoryBot.define do
  factory :vendor do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.sentence }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end
