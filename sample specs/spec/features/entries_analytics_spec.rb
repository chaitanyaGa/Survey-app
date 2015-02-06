require 'spec_helper'

describe "Journal", :js => true, :journal => true, driver: :selenium do
  describe "Analytics", :analytics => true do
    before(:each) do
      create_logged_in_user
    end

    it "should validate correctness of analytics cloud" do

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
        'behaviors' => ['B2'], 
        'wants' => ['W1', 'W3'],
        'emotions' => ['E2' , 'E3'],
        'thoughts' => ['T4', 'T5', 'T6']
      }

      hash[3] = {'who' => ['Who4', 'Who5'], 
        'what' => ['Wht1', 'Wht3', 'Wht4'], 
        'where' => ['Whr1', 'Whr2', 'Whr3', 'Whr4', 'Whr5'], 
        'behaviors' => ['B1', 'B2'], 
        'wants' => ['W3'],
        'emotions' => ['E2', 'E4', 'E5'],
        'thoughts' => ['T1', 'T4', 'T5', 'T6']
      }

      user = User.first
      hash.each do |key, value|
        entry = create(:entry, user: user)
        i= 0
        value.each do |identifier, tag_names| 
          type = EntryItemType.where(identifier: identifier).first
          items = tag_names.collect do |name|
            i += 1
            tag = EntryItemTag.where(name: name).first
            tag = create(:entry_item_tag, name: name) unless tag
            create(:entry_item, entry_item_tag: tag, entry_item_type: type, entry: entry)
          end
        end
      end

      user.entry_items.count.should eq(55)

      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"

      find('li', :text => 'What').click
      within('.tagcloud') do
        expect(page).to have_content "Wht1(3)"
        expect(page).to have_content "Wht2(1)"
        expect(page).to have_content "Wht3(2)"
        expect(page).to have_content "Wht4(1)"
      end

      find('li', :text => 'Who').click
      within('.tagcloud') do
        expect(page).to have_content "Who1(2)"
        expect(page).to have_content "Who3(1)"
        expect(page).to have_content "Who4(2)"
        expect(page).to have_content "Who5(2)"
      end

      find('li', :text => 'Where').click
      within('.tagcloud') do
        expect(page).to have_content "Whr1(3)"
        expect(page).to have_content "Whr2(3)"
        expect(page).to have_content "Whr3(2)"
        expect(page).to have_content "Whr4(2)"
        expect(page).to have_content "Whr5(2)"
      end

      find('li', :text => 'Behaviors').click
      within('.tagcloud') do
        expect(page).to have_content "B1(2)"
        expect(page).to have_content "B2(2)"
      end

      find('li', :text => 'Desires').click
      within('.tagcloud') do
        expect(page).to have_content "W1(2)"
        expect(page).to have_content "W3(3)"
      end

      find('li', :text => 'Emotions').click
      within('.tagcloud') do
        expect(page).to have_content "E1(1)"
        expect(page).to have_content "E2(3)"
        expect(page).to have_content "E3(2)"
        expect(page).to have_content "E4(2)"
        expect(page).to have_content "E5(1)"
      end

      find('li', :text => 'Beliefs').click
      within('.tagcloud') do
        expect(page).to have_content "T1(2)"
        expect(page).to have_content "T2(1)"
        expect(page).to have_content "T3(1)"
        expect(page).to have_content "T4(3)"
        expect(page).to have_content "T5(2)"
        expect(page).to have_content "T6(2)"
      end
    end
  end
end
