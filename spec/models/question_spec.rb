require 'rails_helper'

RSpec.describe Question do
  let(:question)do
    FactoryGirl.create(:question)
  end

  it "has zero or more options ssociated with it"do
    expect(question.options.count).to be >= 0
  end

  it "is must belong to survey"do
    expect(question.survey).not_to be nil
  end

  it "is answered by no users"do
  end

  it "is answered by more than one user"do
  end

  it "is can be modified by admin"do
  end

  it "can not be modified by normal user"do
  end

  it "has multiple responses"do
  end
end
