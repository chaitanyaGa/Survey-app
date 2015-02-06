# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :map_item do
    map_id 1
    map_item_tag_id 1
    map_item_type_id 1
    entry "MyText"
  end
end
