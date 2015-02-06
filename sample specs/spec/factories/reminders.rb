# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reminder do
    name 'test reminder'
    association :user, factory: :user
    active true
    action_type 'NewPlan'
    trait :existing_plan do
      association :action, factory: :new_plan
      before(:create) do |reminder|
        reminder.action_name = reminder.action.name if reminder.action_type == 'NewPlan'
      end
    end
  end
end
