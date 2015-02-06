require 'spec_helper'

describe 'Assessment', js: true, driver: :selenium do

  before(:each) do
    @entry_item_type = EntryItemType.where(identifier: 'wants').first # entry_item_type is "wants"
    
    # setup first entry and tag
    @first_user = create :user
    entry_1 = create :entry, user: @first_user
    @entry_item_tag_1  = create :entry_item_tag
    entry_item_1 = create :entry_item, entry: entry_1, entry_item_type: @entry_item_type, entry_item_tag: @entry_item_tag_1

    #setup second entry and tag
    @second_user = create :user
    entry_2 = create :entry, user: @second_user
    @entry_item_tag_2  = create :entry_item_tag
    entry_item_2 = create :entry_item, entry: entry_2, entry_item_type: @entry_item_type, entry_item_tag: @entry_item_tag_2

    # creating new assessment area for testing because previous assessment area are not loading twice
    # For first test assessment area is loading but for further test cases , 304 not modified response 
    # is send by server because Assessment is common for all user therefore.
    @assessment_area = create :assessment_area 
    @assessment_question = create :assessment_question, assessment_area: @assessment_area, entry_item_type: @entry_item_type
  end

  def reload_page
    visit root_path
    visit journal_path(anchor: "assessment")
  end

  def check_tag_typeahead(available_tags, non_available_tags)
    within('.new-assessment') do
      find('.save').click
      reload_page
      sleep(5)
      all('.section-link').first.click
      all('.bootstrap-tagsinput input').first.click
      all('.bootstrap-tagsinput input').first.click
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(available_tags)
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).to_not match_array(non_available_tags)
    end 
  end

  def setup_assessment_items_tags
    assessment = create :assessment, assessment_area: @assessment_area, user: @first_user
    @assessment_item_tag = create :entry_item_tag

    assessment_item = create :assessment_item, assessment: assessment, assessment_question: @assessment_question, entry_item_tag: @assessment_item_tag, entry_item_type: @entry_item_type
  end

  def check_tags_on_assessment_page(available_tags, non_available_tags)
    sign_in({email: @first_user.email, password: @first_user.password})
    
    sleep(10) #takes time to load collection
    
    visit journal_path(anchor: "assessment")
    expect(page).to have_content('Assessment')

    check_tag_typeahead(available_tags, non_available_tags)
    sign_out
  end

  it "should load tags on assessment page for first_user only" do
    available_tags = [@entry_item_tag_1.name]
    non_available_tags = [@entry_item_tag_2.name]
 
    # Logged in by first_user therefore entry_item_tag_1 is available and entry_item_tag_2 is unavailable
    check_tags_on_assessment_page(available_tags, non_available_tags)

  end

  it "should load tags on assessment page for first_user only" do
    # Assessments type ahead should show assessment_items and entry_items
    setup_assessment_items_tags
    
    # Logged in by first_user and assessment_item_tag present therefore available_tags is submission of both tags
    available_tags = [@entry_item_tag_1.name, @assessment_item_tag.name]
    non_available_tags = [@entry_item_tag_2.name]
  
    check_tags_on_assessment_page(available_tags, non_available_tags)
  end

end
