FactoryGirl.define do
  factory :user do
    name "Chaitanya Gaikwad"
    email "chaitanya@gmail.com"
    age 21
    gender "M"


    after(:build) do |user|
      user.role = Role.find_by_name('admin') || FactoryGirl.create(:role)
    end
  end
end
