# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :thought_item do
    thought nil
    reason_item nil
    entry "MyText"
    score 1
    true_false 1
  end
end
