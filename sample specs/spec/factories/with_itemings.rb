# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :with_iteming do
    with_item nil
    with_itemable nil
    with_itemable_type "MyString"
  end
end
