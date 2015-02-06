require 'spec_helper'

describe "Journal", :js => true, :journal => true, driver: :selenium do
  describe "Analytics 2", :analytics => true do
    before(:each) do
      create_entry
      set_expected_result
    end

    def multiple_attributes
      hash = {}
      hash[1] = {'who' => ['Who1' , 'Who3'], 
        'what' => ['Wht1', 'Wht2', 'Wht3'], 
        'where' => ['Whr1', 'Whr2', 'Whr3'], 
        'behaviors' => ['B1'], 
        'wants' => ['W1', 'W3'],
        'emotions' => ['E1', 'E2' , 'E3', 'E4'],
        'thoughts' => ['T1', 'T2', 'T3', 'T4']
      }

      hash[2] = {'who' => ['Who1', 'Who4', 'Who5'], 
        'what' => ['Wht1'], 
        'where' => ['Whr1', 'Whr2', 'Whr4', 'Whr5'], 
        'behaviors' => ['B2', 'B3'], 
        'wants' => ['W1', 'W3'],
        'emotions' => ['E2' , 'E3'],
        'thoughts' => ['T4', 'T5', 'T6']
      }

      hash[3] = {'who' => ['Who4', 'Who5'], 
        'what' => ['Wht1', 'Wht3', 'Wht4'], 
        'where' => ['Whr1', 'Whr2', 'Whr3', 'Whr4', 'Whr5'], 
        'behaviors' => ['B1', 'B2', 'B4'], 
        'wants' => ['W3'],
        'emotions' => ['E2', 'E4', 'E5'],
        'thoughts' => ['T1', 'T4', 'T5', 'T6']
      }
      hash
    end

    def set_expected_result
      @expected_result_set = []
      @expected_result_set[0] = {
        'who'        => {'Who1' => 'Who1(1)', 'Who3' => 'Who3(1)'}, 
        'what'       => {'Wht1' => 'Wht1(1)', 'Wht2' => 'Wht2(1)', 'Wht3' => 'Wht3(1)'},
        'where'      => {'Whr1' => 'Whr1(1)', 'Whr2' => 'Whr2(1)', 'Whr3' => 'Whr3(1)'},
        'behaviors'  => {'B1' => 'B1(1)'},
        'wants'      => {'W1' => 'W1(1)', 'W3' => 'W3(1)'},
        'emotions'   => {'E1' => 'E1(1)', 'E2' => 'E2(1)', 'E3' => 'E3(1)', 'E4' => 'E4(1)'},
        'thoughts'   => {'T1' => 'T1(1)', 'T2' => 'T2(1)', 'T3' => 'T3(1)', 'T4' => 'T4(1)'}
      }

      @expected_result_set[1] = {
        'who'        => {'Who1' => 'Who1(1)', 'Who4' => 'Who4(1)', 'Who5' => 'Who5(1)'}, 
        'what'       => {'Wht1' => 'Wht1(1)'},
        'where'      => {'Whr1' => 'Whr1(1)', 'Whr2' => 'Whr2(1)', 'Whr4' => 'Whr4(1)', 'Whr5' => 'Whr5(1)'},
        'behaviors'  => {'B2' => 'B2(1)', 'B3' => 'B3(1)'},
        'wants'      => {'W1' => 'W1(1)', 'W3' => 'W3(1)'},
        'emotions'   => {'E2' => 'E2(1)', 'E3' => 'E3(1)'},
        'thoughts'   => {'T4' => 'T4(1)', 'T5' => 'T5(1)', 'T6' => 'T6(1)'}
      }

      @expected_result_set[2] = {
        'who'        => {'Who4' => 'Who4(1)', 'Who5' => 'Who5(1)'}, 
        'what'       => {'Wht1' => 'Wht1(1)', 'Wht3' => 'Wht3(1)', 'Wht4' => 'Wht4(1)'},
        'where'      => {'Whr1' => 'Whr1(1)', 'Whr2' => 'Whr2(1)','Whr3' => 'Whr3(1)', 'Whr4' => 'Whr4(1)', 'Whr5' => 'Whr5(1)'},
        'behaviors'  => {'B1' => 'B1(1)', 'B2' => 'B2(1)', 'B4' => 'B4(1)'},
        'wants'      => {'W3' => 'W3(1)'},
        'emotions'   => {'E2' => 'E2(1)', 'E4' => 'E4(1)', 'E5' => 'E5(1)'},
        'thoughts'   => {'T1' => 'T1(1)', 'T4' => 'T4(1)', 'T5' => 'T5(1)', 'T6' => 'T6(1)'}
      }
    end

    def create_entry
      hash = multiple_attributes
      @first_user  = create :user
      @second_user = create :user
      @third_user  = create :user
      users = [@first_user, @second_user, @third_user]
      hash.each_with_index do |(key, value), index|
        entry = create(:entry, user: users[index])
        value.each do |identifier, tag_names| 
          type = EntryItemType.where(identifier: identifier).first
          items = tag_names.collect do |name|
            tag = EntryItemTag.where(name: name).first
            tag = create(:entry_item_tag, name: name) unless tag
            create(:entry_item, entry_item_tag: tag, entry_item_type: type, entry: entry)
          end
        end
      end
    end

    def check_content(result_set)
      result_set.each do |tag, results|
        results.each do |key, content|
          expect(find(:xpath, "//a[@href='#entries/relation/#{tag}/#{key}']")).to have_content content
        end
      end
    end

    def check_analytics_2(expected_result_set)
      expect(page).to have_content "Awareness Journal - Tag Relation"
      within('.analytics-2') do
        check_content(expected_result_set)
      end
    end

    # At least 3 tags that are common among at least 2 users - in one or more entries
    # Common Tag   |  Common Users
    # Who1            @first_user, @second_user
    # Wht1            @first_user, @second_user, @third_user
    # B2              @second_user, @third_user
    it "should check common tags among 2 users" do
      # login with first user
      sign_in({email: @first_user.email, password: @first_user.password})

      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"

      find('li', :text => 'Who').click
      
      find('a', :text => 'Who1(1)').click
      check_analytics_2(@expected_result_set[0].except('who'))

      find('li', :text => 'What').click
      
      find('a', :text => 'Wht1(1)').click
     
      check_analytics_2(@expected_result_set[0].except('what'))

      sign_out

      # Login with second user
      sign_in({email: @second_user.email, password: @second_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'Who').click

      find('a', :text => 'Who1(1)').click
      check_analytics_2(@expected_result_set[1].except('who'))

      find('li', :text => 'What').click
      find('a', :text => 'Wht1(1)').click
     
      check_analytics_2(@expected_result_set[1].except('what'))
      
      find('li', :text => 'Behaviors').click
      find('a', :text => 'B2(1)').click
     
      check_analytics_2(@expected_result_set[1].except('behaviors'))

      sign_out
      
      # Login with third user
      sign_in({email: @third_user.email, password: @third_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'What').click
      find('a', :text => 'Wht1(1)').click
     
      check_analytics_2(@expected_result_set[2].except('what'))
      
      find('li', :text => 'Behaviors').click
      find('a', :text => 'B2(1)').click
     
      check_analytics_2(@expected_result_set[2].except('behaviors'))

      sign_out
    end

    # At least 2 tags that are common among all the 3 users
    # Common Tag   |  Common Users
    # E2              @first_user, @second_user, @third_user
    # T4              @first_user, @second_user, @third_user
    
    it "should check common tags among 3 users" do
      [@first_user, @second_user, @third_user].each_with_index do |user, index|
        sign_in({email: user.email, password: user.password})
        check_common_tags(index)
        sign_out
      end
    end

    def check_common_tags(index)
      visit journal_path(anchor: 'entries/cloud')
      
      find('li', :text => 'Emotions').click

      find('a', :text => 'E2(1)').click
      check_analytics_2(@expected_result_set[index].except('emotions'))

      find('li', :text => 'Beliefs').click
      find('a', :text => 'T4(1)').click
      check_analytics_2(@expected_result_set[index].except('thoughts'))
    end

    # No tags are commons among the users
    # Tag          |  User
    # B1              @first_user
    # B3              @second_user
    # B4              @third_user
   
    it "should check no common tags amoung the users" do
      [@first_user, @second_user, @third_user].each_with_index do |user, index|
        sign_in({email: user.email, password: user.password})

        visit journal_path(anchor: 'entries/cloud')
        expect(page).to have_content "Awareness Journal - Tag Cloud"

        find('li', :text => 'Behaviors').click
       
        case user
        when @first_user
          find('a', :text => 'B1(1)').click
          check_analytics_2(@expected_result_set[index].except('behaviors'))
        when @second_user
          find('a', :text => 'B3(1)').click
          check_analytics_2(@expected_result_set[index].except('behaviors'))
        when @third_user
          find('a', :text => 'B4(1)').click
          check_analytics_2(@expected_result_set[index].except('behaviors'))
        end
        sign_out
      end
    end

    # User 1 adding a common-tag-with-other-users effects only analytics for the user 1 and not for user 2 or 3
    # Common Tag   |  Common Users
    # E2              @first_user, @second_user, @third_user
    it "should check adding a common-tag-with-other-users effects only analytics for that user" do
      entry = create(:entry, user: @first_user)
      # Create who tag for user 1
      type = EntryItemType.where(identifier: 'who').first
      tag = EntryItemTag.where(name: 'Who1').first
      tag = create(:entry_item_tag, name: 'Who1') unless tag
      create(:entry_item, entry_item_tag: tag, entry_item_type: type, entry: entry)
      
      # Create E2 tag for user 1
      type = EntryItemType.where(identifier: 'emotions').first
      tag = EntryItemTag.where(name: 'E2').first
      tag = create(:entry_item_tag, name: 'E2') unless tag
      create(:entry_item, entry_item_tag: tag, entry_item_type: type, entry: entry)
      
      # login with first user
      sign_in({email: @first_user.email, password: @first_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'Who').click
      find('a', :text => 'Who1(2)').click
      @expected_result_set[0]['emotions']['E2'] = 'E2(2)' # change expected result for user 1
      check_analytics_2(@expected_result_set[0].except('who'))
      sign_out

      # login with second user
      sign_in({email: @second_user.email, password: @second_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      #find('li', :text => 'Emotions').click
      find('li', :text => 'Who').click
      find('a', :text => 'Who1(1)').click
      check_analytics_2(@expected_result_set[1].except('who'))

      sign_out

      # login with third user
      sign_in({email: @third_user.email, password: @third_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      #find('li', :text => 'Emotions').click
      find('li', :text => 'Who').click
      find('a', :text => 'Who4(1)').click
      check_analytics_2(@expected_result_set[2].except('who'))

      sign_out

    end

    # User 2 deleting a entry which has common-tag-with-other-users and the analytics are only affected for the user 2 and not for user 1 or 3
    # Common Tag   |  Common Users
    # E2              @first_user, @second_user, @third_user
    it "should check deleting a common-tag-with-other-users do not effect analytics for other user" do
      type = EntryItemType.where(identifier: 'emotions').first
      tag = EntryItemTag.where(name: 'E2').first
      entry_item = EntryItem.joins(:entry).where(entry_item_tag_id: tag.id, entry_item_type_id: type.id, :'entries.user_id' => @second_user.id).first
      entry = entry_item.entry
      entry.destroy
     
      # E2 tag is deleted for user 2, user 1 and user 2 should have E2 tag
      # login with first user
      sign_in({email: @first_user.email, password: @first_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      #find('li', :text => 'Emotions').click
      find('li', :text => 'Who').click
      find('a', :text => 'Who1(1)').click
      check_analytics_2(@expected_result_set[0].except('who'))

      sign_out

      # login with third user
      sign_in({email: @third_user.email, password: @third_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      #find('li', :text => 'Emotions').click
      find('li', :text => 'Who').click
      find('a', :text => 'Who4(1)').click
      check_analytics_2(@expected_result_set[2].except('who'))

      sign_out
    end

    # User 3 adds a new tag , so that for the first time, the tag becomes common with user 2, 
    # User 2 can have multiple entry with that tag in advance. This tag is not there with any other users. 
    # Check the analytics before and after the operation, and make sure that the analytics correctly change
    
    # Tag      | User
    # B3         @second_user
    it "should add common tag and check analytics before and after the operation" do
      # Before Operation
      # login with second user
      sign_in({email: @second_user.email, password: @second_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'Who').click
      find('a', :text => 'Who4(1)').click
      check_analytics_2(@expected_result_set[1].except('who'))

      
      sign_out

      # login with third user
      sign_in({email: @third_user.email, password: @third_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'Who').click
      find('a', :text => 'Who4(1)').click
      check_analytics_2(@expected_result_set[2].except('who'))
      
      #find('li', :text => 'Behaviors').click
      #within('.tagcloud') do
      #  expect(page).to have_no_content "B3(1)"
      #end
      
      sign_out

      # Operation (Add B3 tag for third_user)
      entry = create(:entry, user: @third_user)
      
      type = EntryItemType.where(identifier: 'who').first
      tag = EntryItemTag.where(name: 'Who4').first
      tag = create(:entry_item_tag, name: 'Who4') unless tag
      create(:entry_item, entry_item_tag: tag, entry_item_type: type, entry: entry)
      
      type = EntryItemType.where(identifier: 'Behaviors').first
      tag = EntryItemTag.where(name: 'B3').first
      tag = create(:entry_item_tag, name: 'B3') unless tag
      create(:entry_item, entry_item_tag: tag, entry_item_type: type, entry: entry)
      
      @expected_result_set[2]['behaviors']['B3'] = 'B3(1)' # set expected result to include b3 tag for user 3
      
      # After Operation
      # login with second user
      sign_in({email: @second_user.email, password: @second_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'Who').click
      find('a', :text => 'Who4(1)').click
      check_analytics_2(@expected_result_set[1].except('who'))
      
      sign_out

      # login with third user
      sign_in({email: @third_user.email, password: @third_user.password})
      
      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"
      
      find('li', :text => 'Who').click
      find('a', :text => 'Who4(2)').click
      check_analytics_2(@expected_result_set[2].except('who'))
      
      sign_out
    end
    
  end
end
