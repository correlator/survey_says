FactoryGirl.define do
  factory :order do
    association :vendor, factory: :vendor
    description { FFaker::DizzleIpsum.sentence }
    price_in_cents { 100}
    close_date { 10.days.from_now }
    status { :pending }
  end
end
