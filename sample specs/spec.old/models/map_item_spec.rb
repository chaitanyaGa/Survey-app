require 'spec_helper'

describe MapItem do
  it { should belong_to(:map)}
  
  it { should validate_presence_of(:map_id) }
  it { should validate_presence_of(:map_item_type_id) }
  it { should validate_presence_of(:map_item_tag_id) }
  it { should validate_uniqueness_of(:map_item_tag_id).scoped_to(:map_id, :map_item_type_id).allow_nil }

end
