FactoryGirl.define do
  factory :entry_item_tag do
    name                  {Faker::Name.first_name} 
  end
end
