# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :needing do
    need nil
    needable_id 1
    needable_type "MyString"
  end
end
