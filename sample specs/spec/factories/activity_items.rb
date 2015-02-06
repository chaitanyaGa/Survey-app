# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_item do
    activity nil
    entry "MyText"
    post nil
    score 1
  end
end
