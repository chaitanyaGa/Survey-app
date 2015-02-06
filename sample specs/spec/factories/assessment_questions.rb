FactoryGirl.define do
  factory :assessment_question do
    association :assessment_area,       factory: :assessment_area
    question_text {Faker::Lorem.sentence}
    association :entry_item_type,       factory: :entry_item_type
  end
end
