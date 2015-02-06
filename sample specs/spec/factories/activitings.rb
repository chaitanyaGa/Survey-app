# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activiting do
    activity nil
    activitable_id 1
    activitable_type "MyString"
  end
end
