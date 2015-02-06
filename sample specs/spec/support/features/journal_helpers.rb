# spec/support/features/journal_helpers.rb
module Features
  module JournalHelpers
    def visit_list_view
      visit journal_path(anchor: 'entries/list')
      expect(page).to have_content "Awareness Journal View"
    end
    
    def visit_micro_view
      visit journal_path(anchor: 'entries/micro')
      expect(page).to have_content("Awareness Timeline View")
    end

    def visit_new_entry_view
      visit journal_path(anchor: 'entries/new')
      expect(page).to have_content("Journal Entry")
    end

    def visit_journal_analytics
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
    end

    def add_tags(type, tags)
      within(".bent_tags_cloud.#{type}", :visible => false) do
        within(".bootstrap-tagsinput", :visible => false) do
          tags.each do |tag|
            case Capybara.current_driver
            when :webkit
              find('input', :visible => false).set("#{tag}\n")
            when :selenium
              find('input', :visible => false).set(tag)
              find('input', :visible => false).native.send_keys(:return)
            end
          end #tags
        end #within
      end #within
    end

    def clear_tags(type)
      within(".bent_tags_cloud.#{type}", :visible => false) do
        within(".bootstrap-tagsinput", :visible => false) do
          all('.label', :visible => false).each do |tag|
            tag.find("[data-role='remove']").click
          end
        end
      end
    end

    def fillin_ratings(ratings)
      within(".bent_tags_cloud.quantitive") do
        all('input').each_with_index do |input, i|
          input.set(ratings[i])
        end
      end
    end

    def fillin_episode(attrs)
      # set dates 
      expect(page).to have_css('.edit_date')
      find('.edit_date').click

      find('#entry_begin_at').set(attrs[:begin_at].strftime('%m/%d/%Y %I:%M %p')) if attrs[:begin_at]
      find('#entry_end_at').set(attrs[:end_at].strftime('%m/%d/%Y %I:%M %p')) if attrs[:end_at]

      fillin_ratings(attrs[:ratings]) if attrs[:ratings]
      if Capybara.current_driver == :selenium
        find('#edit1').click if page.has_css?('.edit_note')
      end
  
      # #edit_note is hidden therefore capybara throwing " Selenium::WebDriver::Error::ElementNotVisibleError:
      # Element is not currently visible and so may not be interacted with "
      # One workaround will be to find('.edit_note').click, but its also not working because of 
      # page.has_css?('.edit_note'). See issue https://github.com/jnicklas/capybara/issues/658
      # second workaround will be to execute script and make element visible
      # Following this issue https://github.com/jnicklas/capybara/issues/856.
      # Capybara 2.1.0 doesnot support interaction with hidden element and accessing element 
      # after using 'has_css?' or 'have_css?' on element.
      page.execute_script("$('.edit_note').click()")

      find('#entry_note', :visible => false).set(attrs[:note]) if attrs[:note]

      # set what who where tags
      attrs[:items].each do |type, tags|
        clear_tags type
        add_tags type, tags
      end if attrs[:items]

      expect(page).to have_selector('a', :text => "Save & Close")
      click_link "Save & Close"
    end

  end

end
