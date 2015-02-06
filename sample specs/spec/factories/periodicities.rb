# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :periodicity do
    level 1
    unit 'day'
    magnitude 5
    association :new_plan, factory: :new_plan
  end
end
