# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :belief_item do
    belief nil
    thought_item nil
    entry "MyText"
    score 1
    true_false 1
  end
end
