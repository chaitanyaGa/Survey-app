FactoryGirl.define do
  factory :response do
    association :user
    association :option
  end

end
