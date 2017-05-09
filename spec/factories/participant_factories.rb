FactoryGirl.define do
  factory :participant do
    name { FFaker::Name.name }
    phone { FFaker::PhoneNumber.short_phone_number.gsub('-', '') }
    email { FFaker::Internet.email }
  end
end
