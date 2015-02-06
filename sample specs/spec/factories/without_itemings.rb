# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :without_iteming do
    without_item nil
    without_itemable_id 1
    without_itemable_type "MyString"
  end
end
