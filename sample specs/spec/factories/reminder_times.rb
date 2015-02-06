# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reminder_time do
    time "2000-01-01 17:45:00"
    days_of_week ['Wed']
    enabled true
    time_zone 'Chennai'
    formatted_time "05:45 PM +0530 (Chennai)"
    association :reminder, factory: :reminder
    repeat true
  end
end
