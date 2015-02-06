require 'spec_helper'

describe "BWETC", :js => true, :bwet => true do
  describe "Emotions", :emotions => true do
    before(:each) do
      create_logged_in_user
      create_map "Emotions-map"
      @tags=["Angry", "Happy", "feeling ok"]
      @tags_to_delete = ["Happy", "feeling ok"]
      @type = "Emotions"
      @default_type = "Neutral"
      @default_intensity = "1"
    end
    
    def expect_tags(tags)
      tags.map { |name,type,intensity| [name, type||@default_type, intensity||@default_intensity] }
    end

    def validate_tags(tags)
      expect_tags(tags).each do |name,type,intensity|
        xpath = ".//div[@data-text='#{name}']"

        within(:xpath, xpath) do
          find("span", :text => name)
          find("sub", :text => intensity)

          find('.action #elink', :text => "Type: #{type}")
          find('.action #ilink', :text => "Intensity: #{intensity}")
        end
      end
    end
    
    def validate_skull_tags(type, tags)
      sleep(3)
      
      tags = expect_tags(tags)
      within(".#{type.singularize.downcase} .tag-box") do
        all(:xpath, ".//a").each do |a|
          _intensity = a.find('sub').text
          text = a.text.gsub(_intensity, '')
          name,type,intensity = tags.detect {|tag| text == tag[0] } #tag[0] is name
          
          expect(intensity).to eql(_intensity)
          expect(name).to eql(text)
          expect(a['data-original-title']).to eql(type)
        end
      end
    end
    
    def change_tags(tags)
      tags.each do |name,type,intensity|
        xpath = ".//div[@data-text='#{name}']"

        within(:xpath, xpath) do
          find('.action #ilink').click
        end
        choose "intensity_#{intensity}"

        within(:xpath, xpath) do
          find('.action #elink').click
        end
        choose "type_#{type}"
      end
      click_button "Map"
    end

    it "should create tags", :skip => true do
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

    it "should allow to change tags and validate change" do
      create_tags @type, @tags
      click_type @type
      
      tags = [%w(Angry Unpleasant 2), %w(Happy Pleasant 3), ["feeling ok","Neutral",'5']]
      change_tags tags
      validate_skull_tags @type, tags
      click_type @type
      validate_tags tags
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
