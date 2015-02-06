FactoryGirl.define do
  factory :entry_item_type do
    name                  {Faker::Name.first_name} 
    identifier            {Faker::Name.first_name} 
  end
end
