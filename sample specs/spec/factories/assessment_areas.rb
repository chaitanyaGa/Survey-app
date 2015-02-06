FactoryGirl.define do
  factory :assessment_area do
    name  {Faker::Name.first_name} 
  end
end


