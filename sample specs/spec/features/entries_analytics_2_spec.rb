require 'spec_helper'

describe "Journal", :js => true, :journal => true, driver: :selenium do
  describe "Analytics 2", :analytics => true do
    before(:each) do
       create_logged_in_user
    end

    it "should validate correctness of analytics cloud" do

      episode = {}
      episode[1] = {
        'what' => ['A', 'B', 'D'],
        'emotions' => ['A', 'B', 'C', 'D'],
        'thoughts' => ['X', 'Y', 'B']
      }
      episode[2] = {
        'what' => ['A', 'B', 'C'],
        'emotions' => ['D', 'E', 'F']
      }
      episode[3] = {
        'what' => ['A', 'B', 'C'],
        'emotions' => ['A', 'C', 'F'],
        'thoughts' => ['A', 'X']
      }

      user = User.first
      episode.each do |key, value|
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

      EntryItem.count.should eq(24)
      user.entry_items.count.should eq(24)

      visit journal_path(anchor: 'entries/cloud')
      expect(page).to have_content "Awareness Journal - Tag Cloud"

      find('li', :text => 'What').click
      within('.tagcloud') do
        expected_result_set = {
          'what' => {'A' => 'A(3)', 'B' => 'B(3)', 'C' => 'C(2)', 'D' => 'D(1)'},
        }
        check_content(expected_result_set)
      end

      find('a', :text => 'A(3)').click
      expect(page).to have_content "Awareness Journal - Tag Relation"
      within('.analytics-2') do
        expected_result_set = {
          'emotions' => {'A' => 'A(2)', 'B' => 'B(1)', 'C' => 'C(2)', 'D' => 'D(2)', 'E' => 'E(1)', 'F' => 'F(2)'},
          'thoughts' => {'A' => 'A(1)', 'B' => 'B(1)', 'X' => 'X(2)', 'Y' => 'Y(1)'},
          'what' => {'B' => 'B(3)', 'C' => 'C(2)', 'D' => 'D(1)'}
         }
         check_content(expected_result_set)
      end

      find('li', :text => 'Emotions').click
      within('.tagcloud') do
        expected_result_set = {
          'emotions' => {'A' => 'A(2)', 'B' => 'B(1)', 'C' => 'C(2)', 'D' => 'D(2)', 'E' => 'E(1)', 'F' => 'F(2)'}
        }
        check_content(expected_result_set)
      end

      find('a', :text => 'A(2)').click
      within('.analytics-2') do
        expected_result_set = {
          'emotions' => {'B' => 'B(1)', 'C' => 'C(2)', 'D' => 'D(1)', 'F' => 'F(1)'},
          'thoughts' => {'A' => 'A(1)', 'B' => 'B(1)', 'X' => 'X(2)', 'Y' => 'Y(1)'},
          'what' => {'A' => 'A(2)', 'B' => 'B(2)', 'C' => 'C(1)', 'D' => 'D(1)'}
         }
         check_content(expected_result_set)
      end
    end

    def check_content(result_set)
      result_set.each do |tag, results|
        results.each do |key, content|
          expect(find(:xpath, "//a[@href='#entries/relation/#{tag}/#{key}']")).to have_content content
        end
      end
    end
  end
end
