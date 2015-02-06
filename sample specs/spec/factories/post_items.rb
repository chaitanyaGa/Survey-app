# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post_item do
    entry "MyText"
    post_item_type nil
    score 1
  end
end
