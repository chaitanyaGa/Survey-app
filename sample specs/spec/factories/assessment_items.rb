FactoryGirl.define do
  factory :assessment_item do
    association :assessment,            factory: :assessment
    association :assessment_question,   factory: :assessment_question
    association :entry_item_tag,        factory: :entry_item_tag
    association :entry_item_type,       factory: :entry_item_type
  end
end

