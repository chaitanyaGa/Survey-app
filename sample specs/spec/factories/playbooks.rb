# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :new_plan do
    name  {Faker::Name.first_name}
    importance 5
    active true
    association :user, factory: :user
    checkin_times 1
    checkin_period 'day'
    trait :regular do
      of_type 'Regular'
    end
    trait :with_periodicities do
      after(:build) do |new_plan| 
        new_plan.periodicities  << FactoryGirl.create(:periodicity, new_plan: new_plan, level: 1, unit: 'hours')
        new_plan.periodicities  << FactoryGirl.create(:periodicity, new_plan: new_plan, level: 2, unit: 'day')
      end
    end
  end

end
