# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :life_without_thought_matching do
    life_without_thought nil
    life_without_thought_matchable_id 1
    life_without_thought_matchable_type "MyString"
  end
end
