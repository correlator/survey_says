FactoryGirl.define do
  factory :order do
    association :vendor, factory: :vendor
    description { FFaker::DizzleIpsum.sentence }
    price_in_cents { 100}
    close_date { Date.new }
    status { 0 }
  end
end
