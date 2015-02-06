FactoryGirl.define do
  factory(:option)do
    option 'good'
    association :question
  end
end
