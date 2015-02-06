FactoryGirl.define do
  factory :entry_item do
    association :entry,       factory: :entry
    association :entry_item_tag,       factory: :entry_item_tag
    association :entry_item_type,       factory: :entry_item_type
  end
end
