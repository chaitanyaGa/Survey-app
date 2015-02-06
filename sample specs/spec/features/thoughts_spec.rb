require 'spec_helper'

describe "BWETC", :js => true, :bwet => true do
  describe "Thoughts", :thoughts => true do
    before(:each) do
      create_logged_in_user
      @title = "Thoughts-New-Map"
      @type = "Thoughts"
      @tags = ["Angry", "Happy", "feeling ok"]
      @tags_to_delete = ["Happy", "feeling ok"]
      create_map @title
    end
    
    def expect_tags(tags)
      tags.map {|name,beliefs,styles| [name, beliefs||[], styles||[]]}
    end

    def validate_tags(tags)
      tags = expect_tags(tags)  
      tags.each do |name,beliefs,styles|
        xpath = ".//div[@data-text='#{name}']"
        within(:xpath, xpath) do
          find("span", :text => name)
          belief_selector = ".action a[data-type=underlying_belief]"
          style_selector = ".action a[data-type=thinking_style]"

          find(belief_selector, :text => "Underlying Beliefs") if beliefs.empty?
          find(style_selector, :text => "Thinking Styles") if styles.empty?
          
          find(belief_selector).text.gsub('Beliefs: ','').split('; ').each do |belief|
            expect(beliefs.detect {|n| n == belief }).to eql(belief)
          end if beliefs.any?

          find(style_selector).text.gsub('Styles: ','').split('; ').each do |style|
            expect(styles.detect {|n| n == style }).to eql(style)
          end if styles.any?

        end
      end
    end
    
    def change_tags(tags)
      belief_selector = ".action a[data-type=underlying_belief]"
      style_selector = ".action a[data-type=thinking_style]"
      
      tags.each do |name,beliefs,styles|
        xpath = ".//div[@data-text='#{name}']"
        within(:xpath, xpath) do
          # Below click fails when used webkit
          # still they fixes it, we will be using selenium
          find(belief_selector).click
        end

        for belief in beliefs
          check "underlying_belief_#{belief}"
        end

        within(:xpath, xpath) do
          # Below click fails when used webkit
          # still they fixes it, we will be using selenium
          find(style_selector).click
        end
        for style in styles
          check "thinking_style_#{style}"
        end
      end
      click_button "Map"
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
    
    it "valid order of tags" do
      create_tags @type, @tags
      click_type @type
      validate_order_of_tags @tags
    end

    it "should allow to change tags and validate change", :driver => :selenium do
      create_tags @type, @tags
      click_type @type
      tags=[["Angry", ["I am unlikable","I am not good enough"], ["Catastrophizing","All or Nothing Thinking"]], 
        ["Happy", ["I am unlikable"], ["Catastrophizing"]], 
        ["feeling ok", ["I am defective"], ["Emotional Reasoning", "Catastrophizing"]]
      ]
      change_tags tags 
      validate_skull_tags(@type, tags)
      click_type @type
      validate_tags tags
    end

    describe "autocomplete", :autocomplete => true do
      before(:each) do
        tags = ["autocomplete", "There's something wrong with me", "something", "i am not lovable", "Interest", "attraction", "Aversion", "greed", "fear", "Alarm"]
        prefill_map("autocomplete-map-1", "Behaviors", tags)
        tags = ["something", "good day", "something with me", "surprise", "Hope", "this is not good", "rest", "joy", "lovely", "this is nice"]
        prefill_map("autocomplete-map-2", "Emotions", tags)
        tags = ["I did something wrong", "this is the last tag", "hell", "not bad", "interesting", "this is cool", "Sympathy", "honour", "pride", "relief", "hope"]
        prefill_map("autocomplete-map-3", @type, tags)
        create_map("Typeahead-Test-Map")
      end
      
      it "should validate pre-existing tag to be on top" do
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
