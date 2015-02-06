require 'spec_helper'

describe MapItemTag do
  it { should have_many(:map_items)}
  
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).case_insensitive.allow_nil }

end
