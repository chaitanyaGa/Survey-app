require 'rails_helper'
RSpec.describe Survey, :type => :model do
  before(:each)do
    @survey = FactoryGirl.build(:survey)
  end

  it 'has valid factory'do
    expect(@survey).to be_valid
  end
  it "has many queation"do
    expect(@survey.question_count).not_to eql 0
  end

  it "has many users"do

  end

  it "has type"do
    expect(@survey.type_of_survey).not_to eql nil
  end

  it "has overall response"do
  end

  it 'has name'do
    expect(@survey.name).not_to eql nil
  end
end
