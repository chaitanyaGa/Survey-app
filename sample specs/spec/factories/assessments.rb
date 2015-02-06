FactoryGirl.define do
  factory :assessment do
    association :assessment_area,       factory: :assessment_area
    association :user, factory: :user
  end
end
