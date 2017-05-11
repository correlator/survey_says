FactoryGirl.define do
  factory :order_participant do
    association :order, factory: :order
    association :participant, factory: :participant
    status { :pending }
  end
end
