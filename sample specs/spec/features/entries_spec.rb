require 'spec_helper'

describe "Journal", :js => true, :journal => true, driver: :selenium do
  describe "Episodes", :entries => true do
    before(:each) do
      @note = "Acceptance test framework for web applications. Contribute to capybara development by creating an account on GitHub."
      create_logged_in_user
    end
    
    def find_calendar_day(date)
      find(".fc-day[data-date='#{date}']")
    end

    def create_entry
      date = Date.today.strftime("%Y-%m-%d")
      # doublick
      find_calendar_day(date).double_click
      
      expect(page).to have_content "Journal Entry"
      # fill in form
      within('.modal') do
        fill_in 'entry_note', :with => @note
      end
      click_link "Save & Close"
    end

    it "should create new episode" do
      visit journal_path(anchor: 'entries')
      create_entry
      within('.fc-view-month') do
        find('.fc-event').should have_content "Misc."
      end
    end
    
    it "should validate only one calendar present after adding new episode" do
      visit journal_path(anchor: 'entries')
      create_entry
      find("#calendar")
      all(:css, '#calendar').count.should == 1
    end

    it "should display created episode" do
      visit journal_path(anchor: 'entries')
      create_entry
      page.should have_selector('.episode.detail')
      within('.episode') do
        find('.header #title').should have_content "Misc."
      end
    end

    it "should update existing episode", focus: true, skip: true do
      visit journal_path(anchor: 'entries')
      create_entry
      page.should have_selector('.episode')
      find('.episode').click
      note2 = "this is update note"
      within('.modal') do
        fill_in 'entry_note', :with => note2
      end
      click_link "Save & Close"
      within('.fc-view-month') do
        find('.fc-event').should have_content "Misc."
      end
    end

    it "should allow delete episode" do
      visit journal_path(anchor: 'entries')
      create_entry
      page.should have_selector('.episode.detail')
      page.execute_script(%Q{window.scrollBy(0,-10000)})
      find('.episode.detail').hover
      page.should have_selector('#delete')
      find('#delete').click
      page.driver.browser.switch_to.alert.accept
    end

    it "should give 10 points for new episode" do
      visit journal_path(anchor: 'entries/micro')
      page.should have_css('#points', :text => "0")
      within('.new-episode') do
        find('.what .bootstrap-tagsinput input').set('new_tag')
        all('.what input').first.set('new_tag')
        find('.spinner[data-id="1"]').set('7')
        find('.save').click
      end
      sleep(1)
      page.should have_css('#points', :text => '10')
      page.should have_css('#bronze_badge_count', :text => '1')

      # delete episode
      all('.icon-remove').first.click
      accept_alert
      sleep(1)
      page.should have_css('#points', :text => '0')
      page.should_not have_css('#bronze_badge_count')
    end
  end

  it 'should show alert box if browser is minimized' do
    page.driver.browser.manage.window.resize_to(600, 400)
    visit new_user_session_path
    page.driver.browser.switch_to.alert.accept
    page.driver.browser.manage.window.resize_to(1300, 900)
    cookie = get_me_the_cookie('alert_shown')
    expect(cookie[:name]).should == 'alert_shown'
    expect(cookie[:value]).should == '1'
    sign_up
  end
end 
