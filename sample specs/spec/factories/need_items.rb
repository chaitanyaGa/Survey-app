# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :need_item do
    need nil
    activity_item nil
    entry "MyText"
    score 1
    true_false 1
  end
end
