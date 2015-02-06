require 'spec_helper'

describe "Journal", :js => true, driver: :selenium do
  describe "Calendar" do
    before(:each) do
      create_logged_in_user
      visit_calendar
      create_multiple_episode
    end

    it "should list episodes" do
      check_multiple_view 
    end

    it "should show last ended episode on the right side", focus: true do
      visit_micro_view
      visit_calendar
      expect(page).to have_selector('.episode.detail')
      expect(page).to have_css(".episode", :text => 'Party', :count => 1) # previous day's entry
    end
    
    it "should update existing episode" do
      opts = episode_options[0]
      visit_date(opts[:date])

      attrs, time = opts[:attrs], opts[:time]
      text = "#{time}#{attrs[:items][:what].first}"
      find('.fc-event-time', text: "#{time} - #{attrs[:items][:what].first}").click

      find('.episode #edit').click

      opts = episode_options[4]
      attrs = opts[:attrs]
      attrs[:begin_at] = Time.now.beginning_of_day + 17.hour - 2.day
      attrs[:end_at] = Time.now.beginning_of_day + 17.hour - 2.day

      fillin_episode(attrs)

      list_view(opts)
    end
 
    # This test case ensure that auto saving on calendar view of episode, also update 
    # collection of episodes and doesnot gives alert showing "Entry cannot be saved as it is modified"
    it "should not show error when updating autosaved episode" do
      # Change auto save timing to auto save episode
      page.execute_script("Happinesspal.auto_save_timer = 8000")
      visit_calendar
      expect(page).to have_selector('.episode.detail')
      find('#edit').click
      attr = { items: {what: %w(New what), who: %w(New who ), where: %w(sea)}, ratings: %w(4 5 6 5 7 7), note: "test" }
      fillin_episode(attr)
      # wait for autosave
      sleep(2)
      # close modal
      find('.close').click
      sleep(1)
      page.execute_script("Happinesspal.auto_save_timer = 60000")
      find('#edit').click
      find('.btn-primary', text: "Save & Close").click
      # no alert message indicates episode saved 
    end

    it "should allow delete episode" do
      page.execute_script("Happinesspal.auto_save_timer = 60000")
      #sleep(1)
      find('#edit').click
      find('.btn-primary', text: "Save & Close").click
      # no alert message indicates episode saved 
    end

    it "should allow delete episode" do
      opts = episode_options[0]
      visit_date(opts[:date])

      #page.should have_selector('.episode.detail')
      find('.episode.detail').hover
      page.should have_selector('#delete')
      find('#delete', :visible=>true).click
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_css(".episode", :count => 0)
      expect(page).not_to have_css(".episode", :text => 'Club')
    end

    def visit_calendar
      date = Date.today.strftime('%B %d %Y')
      visit journal_path(anchor: "entries/month/#{date}")
      expect(page).to have_content("Awareness Calendar View")
    end

    def create_episode(opts={})
      attrs, slot, time = opts[:attrs], opts[:slot], opts[:time]
      visit_date(opts[:date])
      find(".fc-slot#{slot} td").click
      fillin_episode(attrs)
      expect(page).to have_selector('.fc-event-time', text: "#{time} - #{attrs[:items][:what].first}", count: 1)
    end

    def list_view(opts={})
      attrs, time = opts[:attrs], opts[:time]

      visit_date(opts[:date])
      if page.has_css?('.fc-event-title') 
        #expect(find('.fc-event-inner')).to have_content(time)
        #expect(find('.fc-event-inner')).to have_content(attrs[:items][:what].first)
        find('.fc-event-time', text: time).click
      else
        find('.fc-event-time', text: "#{time} - #{attrs[:items][:what].first}").click
      end

      items = attrs[:items]

      within('#entry-episod') do
        items[:what].each do |i|
          expect(find('.header a')).to have_content(i)
        end
        expect(find('.note')).to have_content(items[:note])
        within('.tags') do
          items[:who].each do |value|
            page.should have_selector('span', text: value)
          end

          items[:where].each do |value|
            page.should have_selector('span', text: value)
          end

          %w(Who: Where:).each do |value|
            page.should have_selector('div', text: value)
          end
        end
      end
    end


    def check_multiple_view
      (0..3).each do |i|
        list_view(episode_options[i])
      end
    end

    def create_multiple_episode
      episode_options.each do |options|
        create_episode(options)
      end
    end

    def episode_options
      @episode_options ||= generate_episode_options
    end

    def generate_episode_options
      date = Date.today
      opts = [[3, '1:30', date - 2.day], [5, '2:30', date - 1.day], [7, '3:30', date - 1.day], [9, '4:30', date - 2.day], [11, '5:30', date - 2.day]]
      opts.each_with_index.map do |opt, i|
        {slot: opt[0], time: opt[1], date: opt[2], attrs: multiple_attrs_options[i]}
      end
    end

    def multiple_attrs_options
      [
        { items: {what: %w(Club), who: %w(Shantanu ), where: %w(pune)}, ratings: %w(4 5 6 5 7 7), note: "test" },
        { items: {what: %w(Project), who: %w(Shantanu Sandip), where: %w(mumbai)}, ratings: %w(4 5 6 5 7 7), note: "test" },
        { items: {what: %w(Party), who: %w(Sachin), where: %w(india) }, ratings: %w(4 5 6 5 7 7), note: "test" },
        { items: {what: %w(Work), who: %w(Pratik), where: %w(us) }, ratings: %w(2 5 6 5 3 1), note: "New Note" },
        { items: {what: %w(Songs), who: %w(Pitbull), where: %w(uk) }, ratings: %w(1 3 6 4 7 2), note: "Give me Everything" }
      ]
    end

    def visit_date(dt)
      visit journal_path(anchor: "entries/agendaDay/#{dt.strftime('%B %d %Y')}")
    end
  end
end
