require 'spec_helper'

describe "Journal", :js => true, driver: :selenium do
  describe "Tag Merge", :analytics => true do
    before(:each) do
      create_logged_in_user
    end
    
    def create_episode(attrs)
      visit_new_entry_view
      fillin_episode(attrs)
    end
    
    def create_bundle
      create_episode( { items: {
        what: %w(Wht1 Wht2 Wht3), who: %w(Who1 Who2 Who3),
        behaviors: %w(B1), wants: %w(W1 W3), emotions: %w(E1 E2 E3 E4)}
      })
      expect(page).to have_css(".episode", :count => 1)

      create_episode( { items: {
        what: %w(Wht1), who: %w(Who1 Who2 Who4 Who5),
        behaviors: %w(B2 B3), wants: %w(W1 W3), emotions: %w(E2 E3) }
      })
      expect(page).to have_css(".episode", :count => 2)

      create_episode( { items: {
        what: %w(Wht1 Wht3 Wht4), who: %w(Who4 Who5),
        behaviors: %w(B1 B2), wants: %w(W3), emotions: %w(E2 E4 E5)}
      })
      expect(page).to have_css(".episode", :count => 3)
    end
    
    def click_cloud(type)
      expect(page).to have_selector('li', :text => type)
      find('li', :text => type).click
    end

    def validate_cloud(type, tags, title='')
      click_cloud(type)
      title = type.upcase if title.blank?
      expect(page).to have_selector('.title', :text => title)
      within('.tagcloud') do
        tags.each do |tag|
          expect(page).to have_content tag
        end
      end
    end

    def drag_and_drop(tag1, tag2, tag3=nil)
      within('.tagcloud') do
        expect(page).to have_selector('a', :text => tag1)
        expect(page).to have_selector('a', :text => tag2)

        draggable = find('a', :text => tag1)
        droppable = find('a', :text => tag2)

        draggable.drag_to(droppable)
      end
      expect(page).to have_content("Tag Merge and collapse")
      expect(page).to have_css(".merge-tag", :count => 1)
      find('.merge-tag').set(tag3) if tag3

      expect(page).to have_selector('a', :text => "Replace")
      click_link "Replace"
      accept_alert
      expect(page).not_to have_content("Tag Merge and collapse")
    end

    it "should validate tag cloud" do
      create_bundle
      visit_journal_analytics
      validate_cloud('What', %w(Wht1(3) Wht2(1) Wht3(2) Wht4(1)))
      #validate_cloud('Who', %w(Who1(2) Who2(2) Who3(1) Who4(2) Who5(2)))
      #validate_cloud('Where', %w(Whr1(3) Whr2(3) Whr3(2) Whr4(2) Whr5(2)))
      validate_cloud('Behaviors', %w(B1(2) B2(2) B3(1)))
      validate_cloud('Desires', %w(W1(2) W3(3)), 'WANTS')
      validate_cloud('Emotions', %w(E1(1) E2(3) E3(2) E4(2) E5(1)))
      #validate_cloud('Beliefs', %w(T1(2) T2(1) T3(1) T4(3) T5(2) T6(2)))
    end

    describe "outside cloud (complete new tag)", focus: true do
      it "allows from_tag to become to_tag and count should be equal" do
        create_bundle
        visit_journal_analytics
        click_cloud("What")
        drag_and_drop("Wht1(3)", "Wht4(1)", "Party")
        validate_cloud('What', %w(Party(3) Wht2(1) Wht3(2) Wht4(1)))
      end
    end

    describe "within cloud allows from_tag to become to_tag" do
      it "when both tags are from same episode then total count will be less" do
        create_bundle
        visit_journal_analytics
        click_cloud("What")
        drag_and_drop("Wht1(3)", "Wht4(1)")
        validate_cloud('What', %w(Wht2(1) Wht3(2) Wht4(3)))
      end

      it "when both tags are from different episodes then total count will be equals to the additon of tags" do
        create_bundle
        visit_journal_analytics
        click_cloud("Behaviors")
        drag_and_drop("B1(2)", "B3(1)")
        validate_cloud('Behaviors', %w(B2(2) B3(3)))
      end
    end #describe

  end # tag-merge
end
