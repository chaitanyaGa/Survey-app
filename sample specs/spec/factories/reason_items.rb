# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reason_item do
    reason nil
    feel_item nil
    entry "MyText"
    score 1
  end
end
