# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :context_plan_task do
    context_plan nil
    checkin_item_tag nil
    done_amount 1
    begin_timestamp "2013-03-10 01:09:59"
    end_timestamp "2013-03-10 01:09:59"
  end
end
