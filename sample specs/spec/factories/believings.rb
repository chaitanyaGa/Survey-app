# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :believing do
    belief nil
    believable_id 1
    believable_type "MyString"
  end
end
