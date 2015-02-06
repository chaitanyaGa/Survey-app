require 'spec_helper'

describe "BWETC", :js => true, :bwet => true do
  describe "Behaviors", :behaviors => true do
    before(:each) do
      create_logged_in_user
      @title = "Behaviors-new-Map"
      @type = "Behaviors"
      @tags = ["Angry", "Happy", "feeling ok"]
      @tags_to_delete = ["Happy", "feeling ok"]
      create_map @title
    end

    def expect_tags(tags)
      tags.map {|name,labels| [name, labels||[]]}
    end

    def validate_tags(tags)
      tags = expect_tags(tags)  
      tags.each do |name, labels|
        xpath = ".//div[@data-text='#{name}']"
        within(:xpath, xpath) do
          find("span", :text => name)

          find('.action #link', :text => "Behavior Labels") if labels.empty?
          find('.action #link').text.gsub('Labels: ','').split('; ').each do |label|
            expect(labels.detect {|l| l == label }).to eql(label)
          end if labels.any?
        end
      end
    end

    def validate_uncheck_tags(tags)
      tags = expect_tags(tags)  
      within(".tm-group") do
        all(:xpath, ".//div[@class='tc-tag']").each do |div|
          name, labels = tags.detect {|name, labels| div[:'data-text'] == name }

          div.find("span", :text => name)

          div.find('.action #link', :text => "Behavior Labels") if !labels or labels.empty?
          div.find('.action #link').text.gsub('Labels: ','').split('; ').each do |label|
            expect(labels.detect {|l| l == label }).to eql(label)
          end if labels.any?
        end
      end
    end

    def change_tags(tags, check=true)
      tags.each do |name, labels|
        xpath = ".//div[@data-text='#{name}']"
        within(:xpath, xpath) do
          # somehow below click don't work with webkit
          # still they fixes it we need selenium driver
          find('.action #link').click
        end
        for need in labels
          if check
            check "behavior_label_#{need}"
          else
            uncheck "behavior_label_#{need}"
          end
        end
      end
      click_button "Map"
    end

    def verify_skull_tags(type, tags)
      sleep(4)
      within(".#{type.singularize.downcase} .tag-box") do
        all(:xpath, ".//a").each do |a|
          name, labels = tags.detect {|name, labels| a.text == name }
          labels = ["Not labelled"] if labels.empty?
          a[:title].split(',').each do |label|
            expect(labels.detect {|l| l == label }).to eql(label)
          end
        end
      end
    end

    it "should create tags", :skip => true do
      show_map @title
      create_tags @type, @tags
    end

    it "should prefill tags" do
      create_tags @type, @tags
      click_type @type
      validate_tags @tags
    end

    it "should validate delete tags" do
      create_tags @type, @tags
      click_type @type

      delete_tags(@tags_to_delete)
      @tags -= @tags_to_delete
      validate_skull_tags(@type, @tags)

      click_type @type
      validate_tags @tags
    end

    it "should add labels and validate by coming back from map list page", :driver => :selenium do
      create_tags @type, @tags
      click_type @type
      tags=[["Angry", %w(Mindful Avoidant)], ["Happy", %w(Unmindful)], ["feeling ok", %w(Avoidant Unmindful Mindful)]]
      change_tags tags
      sleep(5)
      click_link "All Maps"
      show_map @title
      verify_skull_tags @type, tags
      click_type @type
      validate_tags tags
    end

    it "should allow to change tags and validate change", :driver => :selenium do
      create_tags @type, @tags
      click_type @type
      tags=[["Angry", %w(Mindful Avoidant)], ["Happy", %w(Unmindful)], ["feeling ok", %w(Avoidant Unmindful Mindful)]]
      change_tags tags
      sleep(5)
      verify_skull_tags @type, tags
      click_type @type
      validate_tags tags
    end
    
    it "should validate labels unselection", :focus => true, :driver => :selenium do
      create_tags @type, @tags
      click_type @type

      tags1=[["Angry", %w(Mindful Avoidant)], ["Happy", %w(Unmindful)], ["feeling ok", %w(Avoidant Unmindful Mindful)]]
      change_tags tags1
      sleep(5)
      verify_skull_tags @type, tags1
      click_type @type
      validate_tags tags1
      
      tags2=[["Angry", %w(Avoidant)], ["Happy", %w(Unmindful)], ["feeling ok", %w(Mindful)]]
      change_tags(tags2, false) # uncheck
      sleep(5)

      tags3=[["Angry", %w(Mindful)], ["Happy", %w()], ["feeling ok", %w(Avoidant Unmindful)]]
      verify_skull_tags @type, tags3
      click_type @type
      validate_uncheck_tags tags3
    end

    it "valid order of tags" do
      create_tags @type, @tags
      click_type @type
      validate_order_of_tags @tags
    end

    describe "autocomplete", :autocomplete => true do
      before(:each) do
        tags = ["autocomplete", "There's something wrong with me", "something", "i am not lovable", "Interest", "attraction", "Aversion", "greed", "fear", "Alarm"]
        prefill_map("autocomplete-map-1", @type, tags)
        tags = ["something", "good day", "something with me", "surprise", "Hope", "this is not good", "rest", "joy", "lovely", "this is nice"]
        prefill_map("autocomplete-map-2", @type, tags)
        tags = ["I did something wrong", "this is the last tag", "hell", "not bad", "interesting", "this is cool", "Sympathy", "honour", "pride", "relief", "hope"]
        prefill_map("autocomplete-map-3", @type, tags)
        create_map("Typeahead-Test-Map")
      end
      
      it "should validate pre-existing tag to be on top", :focus => true do
        typeahead = ["some", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'some', typeahead)
        
        typeahead = ["someth", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'someth', typeahead)
        
        typeahead = ["somethin", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'somethin', typeahead)
        
        typeahead = ["something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'something', typeahead)
      end

      it "should allow brand-new multiword tag if atleast one word matches" do
        typeahead = ["something cheezy", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'something cheezy', typeahead)
      end

      it "should allow brand-new multiword tag if atleast one word matches - 2" do
        typeahead = ["cheezy some", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'cheezy some', typeahead)

        typeahead = ["cheezy someth", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'cheezy someth', typeahead)

        typeahead = ["cheezy something", "something", "something with me", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'cheezy something', typeahead)
      end

      it "2 gram autocomplete match" do
        typeahead = ["something wrong", "I did something wrong", "There's something wrong with me"]
        validate_typeahead(@type, 'something wrong', typeahead)
        
        typeahead = ["something with", "something with me"]
        validate_typeahead(@type, 'something with', typeahead)
     end
    end
  end
end # End of BWETC
