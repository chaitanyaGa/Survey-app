FactoryGirl.define do
  factory :entry do
    note  'Note'
    title 'Title'
    begin_at Time.now
    end_at Time.now
    association :user,       factory: :user
  end
end
