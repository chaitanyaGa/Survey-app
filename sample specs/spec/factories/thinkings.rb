# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :thinking do
    thought nil
    thinkable_id 1
    thinkable_type "MyString"
  end
end
