require 'spec_helper'

describe 'Assessment', js: true, driver: :selenium do

  before(:each) do
    @user = create_logged_in_user
  end

  it 'should add assessment badge and points if any question is answered ' do
    visit journal_path(anchor: "assessment")
    page.should have_css('#points', :text => 0)
    expect(page).to have_content('Assessment')

    add_tag(2, 1, 1)
    add_tag(3, 3, 1)
    add_tag(4, 5, 1)
    remove_tag(2, 3, 1)
    remove_tag(3, 1, 1)
    remove_tag(4, 0, 0)
  end

  def fill_tags(number) 
    within("#fieldset_#{number} .bootstrap-tagsinput") do
      find('input').set('Test case pass')
      find('input').native.send_keys(:return)
    end
  end

  def add_tag(number, points, badge_count)
    within('.new-assessment') do
      sleep(5)
      all('.section-link').first.click
      sleep(1)
      fill_tags(number)
      click_button('Save')
      sleep(5)
      visit root_path
      visit journal_path(anchor: "assessment")
    end
    page.should have_css('#points', :text => points)
    page.should have_css('#bronze_badge_count', :text => badge_count)
  end

  def remove_tag(number, points, badge_count)
    within('.new-assessment') do
      sleep(5)
      all('.section-link').first.click
      sleep(1)
      within("#fieldset_#{number} .bootstrap-tagsinput") do
        clear_triggers
      end
      click_button('Save')
      sleep(5)
      visit root_path
      visit journal_path(anchor: "assessment")
    end
    page.should have_css('#points', :text => points)
    if badge_count == 0
      page.should_not have_css('#bronze_badge_count')
    else
      page.should have_css('#bronze_badge_count', :text => badge_count)
    end
  end


  def clear_triggers
    all('.label').each do |tag|
      tag.find("[data-role='remove']").click
    end
  end
end
