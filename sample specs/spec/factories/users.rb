# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    sequence(:email)      {|i | i.to_s + Faker::Internet.email}
    password 'please'
    password_confirmation 'please'
  end
end
