# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :action_iteming do
    action_item nil
    action_itemable nil
    action_itemable_type "MyString"
  end
end
