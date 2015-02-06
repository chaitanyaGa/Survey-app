require 'spec_helper'

describe Map do
  before(:each) do
    @map = FactoryGirl.build(:map)
  end

  it { should have_many(:map_items)}
  it { should belong_to(:user)}
  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }
  it { should validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id).allow_nil }

end
