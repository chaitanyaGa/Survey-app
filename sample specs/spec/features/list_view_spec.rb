require 'spec_helper'

describe "List View", :js => true, :list => true, driver: :selenium do
  describe "Episodes" do
    before(:each) do
      create_logged_in_user
    end

    def click_new_episode
      expect(page).to have_css('.new_entry', :text => "New Episode")
      all('.new_entry').first.click
      expect(page).to have_content("Journal Entry")
    end
    
    def click_expand_all
      expect(page).to have_css('.expand_all', :text => "Expand All")
      all('.expand_all').first.click
    end

    def click_collapse_all
      expect(page).to have_css('.collapse_all', :text => "Collapse All")
      all('.collapse_all').first.click
    end
    
    def select_date(dt)
      expect(page).to have_css('.smallDatePicker')
      
      input = all('.smallDatePicker').first
      case Capybara.current_driver
      when :selenium
        input.set(dt.strftime('%m/%d/%Y'))
        input.native.send_keys(:return)
      when :webkit
        input.set("#{dt.strftime('%m/%d/%Y')}\n")
      end
    end

    def create_episode(attrs)
      click_new_episode
      fillin_episode(attrs)
    end
    
    def update_episode(attrs)
      fillin_episode(attrs)
    end

    it "should able to navigate to list view" do
      visit_list_view
    end
    
    it "should create new episode" do
      visit_list_view
      create_episode( { items: {what: %w(Club Party), who: %w(Sandip Shantanu Sachin), where: %w(pune) },
                     ratings: %w(4 5 6 5 7 7), note: "test test test test" })

      expect(page).to have_css(".episode", :count => 1)
      expect(page).to have_selector('.episode .what', text: 'Club Party')
      
      click_expand_all

      expect(find('.episode .tags')).to have_content('Who: Sandip Shantanu Sachin', :count => 1)
      expect(find('.episode .tags')).to have_content('Where: pune', :count => 1)
      expect(page).to have_selector('.episode .ratings', :text => '4 5 6 5 7 7')
    end

    it "should list episodes" do
      visit_list_view
      create_episode( { items: {what: %w(Club Party), who: %w(Sandip Shantanu Sachin) }})
      expect(page).to have_css(".episode", :count => 1)

      create_episode( { items: {what: %w(Cricket), who: %w(Andrew Sanjiv) }})
      expect(page).to have_css(".episode", :count => 2)

      create_episode( { items: {what: %w(Presentation), who: %w(Shantanu) }})
      expect(page).to have_css(".episode", :count => 3)

      visit bent_path
      visit_list_view

      expect(page).to have_css(".episode", :count => 3)
    end

    it "should validate order of listing", focus: true do
      visit_list_view
      
      ydt = Date.yesterday
      create_episode( { begin_at: ydt, end_at: ydt, items: {what: %w(Club) }}) #begin time y'day
      expect(page).to have_css(".episode", :count => 1)

      yydt = (Date.today - 3.days)
      create_episode( { begin_at: yydt, end_at: yydt, items: {what: %w(Party) }}) #begin time day before y'day
      expect(page).to have_css(".episode", :count => 2)

      dt = Date.today
      create_episode( { begin_at: dt, end_at: dt, items: {what: %w(Study) }}) #begin time begining of today
      expect(page).to have_css(".episode", :count => 3)
      
      # visit somewhere else and come back to validate order
      visit_micro_view
      visit_list_view

      select_date(yydt)

      expect(page).to have_css(".episode", :count => 3)
      
      # get sorted episodes based on begin_at
      ordered = %w(Party Club Study)
      # get all episodes and iterate to validate the order
      all('.episode').each_with_index do |row, i|
        expect(row).to have_content ordered[i]
      end
    end  
    
    it "should show episodes only for the selected date" do
      visit_list_view
      
      ydt = Date.yesterday
      create_episode( { begin_at: ydt, end_at: ydt, items: {what: %w(Club) }}) #begin time y'day
      expect(page).to have_css(".episode", :count => 1)

      create_episode( { items: {what: %w(Party) }})
      expect(page).to have_css(".episode", :count => 2)

      dt = Date.today
      create_episode( { begin_at: dt, end_at: dt, items: {what: %w(Study) }}) #begin time begining of today
      expect(page).to have_css(".episode", :count => 3)
      
      # visit somewhere else and come back to validate order
      visit_micro_view
      visit_list_view

      select_date(dt)

      expect(page).to have_css(".episode", :count => 2)
    end

    it "should validate expand/collapse functionality" do
      visit_list_view
      
      create_episode( { items: {what: %w(Club Party), who: %w(Sandip Shantanu Sachin), where: ['Bamboo house'] }})
      expect(page).to have_css(".episode", :count => 1)
      
      create_episode( { items: {what: %w(Cricket), who: %w(Pratik) }})
      expect(page).to have_css(".episode", :count => 2)
      
      create_episode( { items: {what: %w(Session), who: %w(Sandip), where: %w(pune) }})
      expect(page).to have_css(".episode", :count => 3)
      
      click_expand_all
      
      expect(page).to have_css('.episode .tags', :text => 'Who: Sandip Shantanu Sachin', :count => 1)
      expect(page).to have_css('.episode .tags', :text => 'Who: Pratik', :count => 1)
      expect(page).to have_css('.episode .tags', :text => 'Who: Sandip Where: pune', :count => 1)
      
      click_collapse_all

      expect(page).not_to have_content('Who: Sandip Shantanu Sachin')
      expect(page).not_to have_content('Who: Pratik')
      expect(page).not_to have_content('Who: Sandip Where: pune')
    end

    it "should update existing episode" do
      visit_list_view
      
      create_episode( { items: {what: %w(Club Party), who: %w(Sandip Shantanu Sachin), where: ['Bamboo house'] }})
      expect(page).to have_css(".episode", :count => 1)
      
      create_episode( { items: {what: %w(Session), who: %w(Sandip), where: %w(pune) }})
      expect(page).to have_css(".episode", :count => 2)

      create_episode( { items: {what: %w(Cricket), who: %w(Pratik) }})
      expect(page).to have_css(".episode", :count => 3)
     
      # visit somewhere else and come back to update episode
      visit balances_path
      visit_list_view
      

      within('.episode', :text => 'Cricket') do
        find('.icon-edit').click
      end

      update_episode( { items: {what: %w(Hockey), who: %w(Sandip), where: %w(chicago)}, ratings: %w(4 5 6 5 7 7) })
     
      expect(page).not_to have_selector('.episode .what', :text => 'Cricket')
      expect(page).to have_selector('.episode .what', :text => 'Hockey')
      expect(page).to have_selector('.episode .ratings', :text => '4 5 6 5 7 7')

      within('.episode', :text => 'Hockey') do
        expect(page).to have_css('.icon-chevron-right')
        find('.icon-chevron-right').click
        expect(page).not_to have_content('Who: Pratik')
        expect(find('.tags')).to have_content('Who: Sandip Where: chicago')
      end
    end

    it "should allow delete episode" do
      visit_list_view
      create_episode( { items: {what: %w(Club Party), who: %w(Sandip Shantanu Sachin), where: ['Bamboo house'] }})
      expect(page).to have_css(".episode", :count => 1)
      
      create_episode( { items: {what: %w(Cricket), who: %w(Pratik) }})
      expect(page).to have_css(".episode", :count => 2)
      
      create_episode( { items: {what: %w(Session), who: %w(Sandip), where: %w(pune) }})
      expect(page).to have_css(".episode", :count => 3)
      
      expect(page).to have_css('.icon-remove', :count => 3)
      
      within('.episode', :text => 'Cricket') do
        find('.icon-remove').click
      end

      accept_alert 

      expect(page).to have_css(".episode", :count => 2)

      expect(page).not_to have_selector('.episode .what', :text => 'Cricket')

      visit bent_path
      visit_list_view

      expect(page).to have_css(".episode", :count => 2)
    end

  end
end
