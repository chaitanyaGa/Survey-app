# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    name "Reminder"
    value "05:30 PM +0530"
    user_id 1
  end
end
