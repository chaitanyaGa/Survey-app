require 'spec_helper'

describe "Micro Journal", :js => true, :micro => true, driver: :selenium do
  describe "Episodes" do
    before(:each) do
      create_logged_in_user
    end

    def fill_micro_ratings(ratings)
      all('input')[1..-1].each_with_index do |input, i|
        input.set(ratings[i])
      end
    end

    def add_what_tag(what=[])
      expect(page).to have_selector('.bootstrap-tagsinput')
      within('.bootstrap-tagsinput') do
        what.each do |tag|
          find('input').set(tag)
          if Capybara.current_driver == :selenium
            sleep(0.5)
          end
          find('input').native.send_keys(:return)
        end
      end 
    end

    def create_micro_episode(attrs)
      within('.new-episode') do

        add_what_tag(attrs[:what]) if attrs[:what]

        fill_micro_ratings(attrs[:ratings]) if attrs[:ratings]

        find('.icon-plus').click
      end
    end

    def create_episode_bundle
      create_micro_episode({ what:%w(Club Party) })
      expect(page).to have_css(".episode", :count => 1)

      create_micro_episode({ what:%w(Movie) })
      expect(page).to have_css(".episode", :count => 2)

      create_micro_episode({ what:%w(Study Play) })
      expect(page).to have_css(".episode", :count => 3)
    end

    it "should able to navigate to micro-journal view" do
      visit_micro_view
    end

    it "should create micro episode"do
      visit_micro_view
      create_micro_episode({ what:%w(Club Party), ratings: %w(5 6 6 7 7 7) })

      expect(page).to have_css(".episode", :count => 1)

      find('.episode .what').should have_content('Club')
      expect(page).to have_css(".episode", :text => 'Club + 5 6 6 7 7 7')
    end

    it "should list episodes" do
      visit_micro_view

      create_micro_episode({ what:%w(Club Party) })
      expect(page).to have_css(".episode", :count => 1)

      create_micro_episode({ what:%w(Cricket) })
      expect(page).to have_css(".episode", :count => 2)

      create_micro_episode({ what:%w(Presentation) })
      expect(page).to have_css(".episode", :count => 3)

      visit bent_path
      visit_micro_view
      expect(page).to have_css(".episode", :count => 3)
    end

    it "should update existing micro episode" do
      visit_micro_view

      create_episode_bundle

      create_micro_episode({ what:%w(Cricket) })
      expect(page).to have_css(".episode", :count => 4)

      within('.episode', :text => 'Cricket') do
        # click edit icon
        find('.icon-pencil').click

        within(".bootstrap-tagsinput") do

          # empty pre-tags
          all('.label').each do |tag|
            tag.find("[data-role='remove']").click
          end
          # fill new tags
          %w(Study Exam).each do |tag|
            find('input').set(tag)
            find('input').native.send_keys(:return)
          end
        end

        fill_micro_ratings(%w(4 5 6 6 7 7))

        # save episode
        find(".icon-plus").click
      end

      expect(page).not_to have_css(".episode", :text => "Cricket")
      expect(page).to have_css(".episode", :text => "Study + 4 5 6 6 7 7")
    end

    it "should allow delete episode" do
      visit_micro_view

      create_episode_bundle

      create_micro_episode({ what:%w(Cricket) })
      expect(page).to have_css(".episode", :count => 4)

      within('.episode', :text => 'Cricket') do
        find('.icon-remove').click
      end

      page.driver.browser.switch_to.alert.accept

      expect(page).to have_css(".episode", :count => 3)
      expect(page).not_to have_css(".episode", :text => 'Cricket')

      visit bent_path
      visit_micro_view

      expect(page).to have_css(".episode", :count => 3)
    end

    # Specs testing episode create/update using overlay
    #
    def click_new_episode
      expect(page).to have_css('.new-episode')
      within('.new-episode') do
        find('.icon-edit').click
      end
      expect(page).to have_content("Journal Entry")
    end

    it "should not reset the editing entry while appending the second fetch of entries" do
      visit balances_path
      user = User.first
      file = File.read('./spec/support/temp.json')
      all_entries = JSON.parse file
      all_entries.each do |entry_attrs|
        entry_attrs.delete('id')
        items_attrs = entry_attrs.delete('items')
        rating_attrs = entry_attrs.delete('ratings')
        tag_types = entry_attrs.delete('tag_types')
        user.entries.create_with_tags(entry_attrs, items_attrs, rating_attrs, tag_types)
      end
      visit_micro_view
      sleep(1)
      create_micro_episode({ what:%w(Club Party) })
      create_micro_episode({ ratings: %w(5 6 6 7 7 7), what: %w(Cricket Cricket) })

      visit bent_path
      visit_micro_view
      sleep(2)
      #expect(page).to have_css(".episode", :count => 61)
      within('.episode', :text => 'Cricket') do
        # click edit icon
        find('.icon-pencil').click

        within(".bootstrap-tagsinput") do

          # empty pre-tags
          all('.label').each do |tag|
            tag.find("[data-role='remove']").click
          end
          # fill new tags
          %w(Hockey).each do |tag|
            find('input').set(tag)
            find('input').native.send_keys(:return)
          end
        end

        # save episode
        find(".icon-plus").click
      end
    end

    it "should able to create episode using overlay", focus: true do
      visit_micro_view
      create_episode_bundle

      click_new_episode
      fillin_episode( { items: {what: %w(Hockey), who: %w(Sandip)}, ratings: %w(4 5 6 5 7 7) })

      expect(page).to have_css(".episode", :count => 4)
      expect(page).to have_css(".episode", :text => 'Hockey 4 5 6 5 7 7')
    end

    it "should able to update episode using overlay", focus: true do
      visit_micro_view
      create_episode_bundle

      create_micro_episode({ what:%w(Cricket), ratings: %w(4 4 4 6 6 6) })
      expect(page).to have_css(".episode", :count => 4)
      expect(page).to have_css(".episode", :text => 'Cricket 4 4 4 6 6 6')

      within(".episode", :text => 'Cricket 4 4 4 6 6 6') do
        find('.icon-edit').click
      end
      expect(page).not_to have_content("Journal Entry")

      fillin_episode( { items: {what: %w(Hockey), who: %w(Sandip)}, ratings: %w(4 5 6 5 7 7) })

      expect(page).not_to have_css(".episode", :text => 'Cricket 4 4 4 6 6 6')

      expect(page).to have_css(".episode", :count => 4)
      expect(page).to have_css(".episode", :text => 'Hockey 4 5 6 5 7 7')
    end

    it 'when no what tag is added and only ratings are added, modal should reflect rating changes' do
      visit_micro_view
      ratings =  %w(1 2 3 4 5 6) 
      within('.new-episode') do
        fill_micro_ratings(ratings) 
      end

      find('.icon-edit').click
      expect(page).not_to have_content(ratings.join(' '))
    end

    def check_what_tag_values(what)
      add_what_tag(what) 
      find('.new-episode .icon-edit').click
      expect(page).to have_css(".bent_form .bootstrap-tagsinput", :text => what.join(' '))
    end

    it 'what_tag in modal should not show duplicate entries(previous what_tag values)' do
      visit_micro_view
      check_what_tag_values(['football', 'sachin'])
      click_link "Save & Close"
      check_what_tag_values(['sandip'])
      within('.bent_form') do
        expect(page).not_to have_content('football')
        expect(page).not_to have_content('sachin')
      end
    end

    context '#typeahead list' do
      it 'should select only the clicked value from the auto-generated list and not the value entered in text box' do
        visit_micro_view
        create_micro_episode({ what:%w(Club Party), ratings: %w(5 6 6 7 7 7) })
        sleep 2
        within('.bootstrap-tagsinput') do
          find('input').set('Cl')
        end 
        page.should have_selector('li', text: 'ub')
        find('li', :text => 'ub').click
        within('.bootstrap-tagsinput') do
          expect(page).to have_css("span.tag", :count => 1)
          expect(page).to have_content('Club')
        end
      end
    end

    context 'Auto Sync: Fetch modified collection form the server and rerender the page' do
      context 'should update page' do
        it 'if new entry created' do
          visit_micro_view
          create_micro_episode({what:%w(Club)})
          expect(page).to have_css(".episode", :count => 1)

          entry = Entry.last
          original_user = entry.user
          new_user = create(:user)

          #Change user of entry 
          entry.update_attribute(:user, new_user)
          sleep(60)
          expect(page).to have_css(".episode", :count => 0)

          #Reassign the original_user to entry
          entry.update_attribute(:user, original_user)
          sleep(60)
          expect(page).to have_css(".episode", :count => 1)
        end
      end

      it 'should not autosave multiple times in a minute' do
        visit_micro_view
        create_micro_episode({ what:%w(Cricket) })

        within('.episode', :text => 'Cricket') do
          # click edit icon
          find('.icon-edit').click
        end

        within('.bent_tags_cloud.who') do
          within('.bootstrap-tagsinput') do
            find('input').set('another-who')
          end 
        end
        sleep(10)
        find('.close').click
        #should not be autosaved

        within('.episode', :text => 'Cricket') do
          # click edit icon
          find('.icon-edit').click
        end
        expect(page).not_to have_selector('span', text: 'another-who')
        
        within('.bent_tags_cloud.who') do
          within('.bootstrap-tagsinput') do
            find('input').set('another-who')
          end 
        end 
        sleep 62
        find('.close').click
        #should be autosaved
        sleep(1)

        within('.episode', :text => 'Cricket') do
          # click edit icon
          find('.icon-edit').click
        end
        sleep(1)
        expect(page).to have_selector('span', text: 'another-who')
        
      end

      it 'should not rerender page while editing a entry' do
        visit_micro_view

        create_episode_bundle

        create_micro_episode({ what:%w(Cricket) })
        expect(page).to have_css(".episode", :count => 4)

        within('.episode', :text => 'Cricket') do
          # click edit icon
          find('.icon-pencil').click

          within(".bootstrap-tagsinput") do

            # empty pre-tags
            all('.label').each do |tag|
              tag.find("[data-role='remove']").click
            end
            # fill new tags
            %w(Study Exam).each do |tag|
              find('input').set(tag)
              find('input').native.send_keys(:return)
            end
          end

          fill_micro_ratings(%w(4 5 6 6 7 7))

          # save episode
          find(".icon-plus").click
        end

        expect(page).not_to have_css(".episode", :text => "Cricket")
        expect(page).to have_css(".episode", :text => "Study + 4 5 6 6 7 7")
        Entry.destroy_all
        sleep(70)
        expect(page).to have_css(".episode", :count => 0)
      end
    end
  end
end
