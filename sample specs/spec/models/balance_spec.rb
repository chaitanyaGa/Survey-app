require 'spec_helper'

describe Balance do
  before(:each) do
    @balance = FactoryGirl.build(:balance)
  end

  it { should belong_to(:user)}
  it { should belong_to(:entry_item_type)}
  it { should belong_to(:entry_item_tag)}
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:entry_item_type_id) }
  it { should validate_presence_of(:entry_item_tag_id) }
end
