# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regular_plan_task do
    regular_plan nil
    done_amount 1
    begin_timestamp "2013-03-11 01:37:38"
    end_timestamp "2013-03-11 01:37:38"
  end
end
