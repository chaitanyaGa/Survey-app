FactoryGirl.define do
  sequence(:age){|age| "#{18+age}"}
  factory :user do
    name "Chaitanya Gaikwad"
    email "chaitanya@gmail.com"
    age
    gender "M"
    association :role
=begin
    after(:build) do |user|
      user.role = Role.find_by_name('admin') || FactoryGirl.create(:role)
    end

=end
  end

end
