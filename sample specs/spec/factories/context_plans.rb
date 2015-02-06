# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :context_plan do
    name "MyString"
    description "MyText"
    task_amount 1
    plan_task_amount_type nil
    checkin_times 1
    checkin_period_id 1
    importance 1
  end
end
