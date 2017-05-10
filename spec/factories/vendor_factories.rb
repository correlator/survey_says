FactoryGirl.define do
  factory :vendor do
    name { FFaker::Company.name }
  end
end
