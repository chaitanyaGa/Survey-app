# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :checkin_item do
    post nil
    checkin_item_type nil
    checkin_item_tag nil
    entry "MyText"
    score 1
    true_false 1
  end
end
