# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_log do
    receipient_email "MyString"
    subject "MyString"
    content "MyText"
    date "2014-08-08"
    day "MyString"
  end
end
