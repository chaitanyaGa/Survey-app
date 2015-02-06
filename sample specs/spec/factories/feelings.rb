# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feeling do
    feel nil
    feelable_type "MyString"
    feelable_id 1
  end
end
