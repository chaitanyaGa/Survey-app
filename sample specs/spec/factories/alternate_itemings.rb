# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alternate_iteming do
    alternate_item nil
    alternate_itemable_id 1
    alternate_itemable_type "MyString"
  end
end
