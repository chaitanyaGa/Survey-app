# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :balance do
    user_id 1
    entry_item_tag_id 1
    entry_item_type_id 1
    true_false false
  end
end
