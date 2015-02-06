require 'spec_helper'

describe "Awareness Maps", :js => true do
  before(:each) do
    create_logged_in_user
    @title = "BWET-NEW-MAP"
  end

  it "create new Map" do
    create_map @title
  end

  it "GET /bent list of maps" do
    # there is one more container which has new_map link
    10.times { |i| 
      create_map("bent-map-#{i+1}") 
      click_link "All Maps"
      within('.container-fluid') do
        all(:css, ".u_container").length.should eql(i+2)
      end
    }
    visit bent_path
    delete_map "bent-map-5"
    visit bent_path
    within('.container-fluid') do
      all(:css, ".u_container").length.should eql(10)
    end
  end

  it "should able to delete map", :driver => :selenium do
    create_map @title
    click_link "All Maps"
    map = find(".u_container .u3_normal >p", :text => @title).find(:xpath, '../../..')
    map.hover
    map.find('.delete').click
    page.driver.browser.switch_to.alert.accept
    page.driver.browser.switch_to.alert.accept
  end

  it "should able to delete map using webkit" do
    5.times { |i| create_map("bent-map-#{i+1}") }
    click_link "All Maps"
    delete_map "bent-map-3"
  end

  it "should validate order of BWETC #{%w(Circumstances Emotions Thoughts Behaviors Wants).join("-->")}", :focus => true do
    %w(Circumstances Emotions Thoughts Behaviors Wants)
    visit bent_path
    create_map @title
    click_type "#circumstance"
    expect(page).to have_content 'Circumstances'
    find(".next").click
    expect(page).to have_content 'Emotions'
    find(".next").click
    expect(page).to have_content 'Thoughts'
    find(".next").click
    expect(page).to have_content 'Behaviors'
    find(".next").click
    expect(page).to have_content 'Wants'
    find(".back").click
    expect(page).to have_content 'Behaviors'
    find(".back").click
    expect(page).to have_content 'Thoughts'
    find(".back").click
    expect(page).to have_content 'Emotions'
    find(".back").click
    expect(page).to have_content 'Circumstances'
  end

  it "should validate map show page displays tags with special characters" do
    visit bent_path
    create_map @title
    type = "Behaviors"
    tags = %w(`~!@#$%^ `~!@#$% *()_+=-)
    create_tags type, tags 
    validate_skull_tags type, tags
  end
end
