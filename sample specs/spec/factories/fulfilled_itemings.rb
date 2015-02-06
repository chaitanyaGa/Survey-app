# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fulfilled_iteming do
    fulfilled_item nil
    fulfilled_itemable_id 1
    fulfilled_itemable_type "MyString"
  end
end
