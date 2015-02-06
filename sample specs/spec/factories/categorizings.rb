# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :categorizing do
    category nil
    categorizable_type "MyString"
    categorizable_id 1
  end
end
