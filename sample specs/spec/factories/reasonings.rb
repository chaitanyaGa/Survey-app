# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reasoning do
    reason nil
    reasonable_type "MyString"
    reasonable_id 1
  end
end
