# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feel_item do
    feel nil
    entry "MyText"
    activity_item nil
    score 1
  end
end
