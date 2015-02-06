require 'spec_helper'

describe Setting do
  before(:each) do
    @setting = FactoryGirl.build(:setting)
  end

  it { should belong_to(:user)}
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:user_id).allow_nil }

end
