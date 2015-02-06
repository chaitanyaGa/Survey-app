# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :need_fulfilled_stating do
    need_fulfilled_state nil
    need_fulfilled_stateable_id 1
    need_fulfilled_stateable_type "MyString"
  end
end
