FactoryGirl.define do
  factory :question do
    association :survey
    question 'how was your day?'
  end
end
