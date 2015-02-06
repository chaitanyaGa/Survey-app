require 'spec_helper'

describe MapItemType do
  it { should have_many(:map_items)}
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:identifier) }
  it { should validate_uniqueness_of(:identifier).case_insensitive.allow_nil }

end
