FactoryGirl.define do
  factory :survey do
    name 'education'
    type_of_survey 'general'
    conducted '2015-02-02'
    no_of_people 3
    question_count 3
  end
end
