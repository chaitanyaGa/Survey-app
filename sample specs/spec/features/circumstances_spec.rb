require 'spec_helper'

describe "BWETC", :js => true, :bwet => true do
  describe "Circumstances", :circumstances => true do
    before(:each) do
      create_logged_in_user
      @title = "Circumstances-new-Map"
      @type = "#circumstance"
      @tags=["Angry", "Happy", "feeling ok"]
      @tags_to_delete = ["Happy", "feeling ok"]
      @default_type = "What"
      create_map @title
    end
    
    def expect_tags(tags)
      tags.map {|name, type| [name, type||@default_type] }
    end

    def validate_tags(tags)
      tags = expect_tags(tags)
      tags.each do |name, type|
        xpath = ".//div[@data-text='#{name}']"

        within(:xpath, xpath) do
          
          find("span", :text => name)
          find('.action #link', :text => "Type: #{type}")
        end
      end
    end
    
    def validate_skull_tags(type, tags)
      sleep(2) # skull yet to be prepared
      tags = expect_tags(tags)
      within(type) do
        all(:xpath, ".//p").each do |p|
          name, type = tags.detect {|name, type| p.text == "#{name} (#{type})" }

          expect("#{name} (#{type})").to eql(p.text)
          expect(p['data-original-title']).to eql(type)
        end
      end
    end

    def validate_order_of_tags(tags)
      within(".tm-group") do
        ordered_tags = tags.reverse
        all(:xpath, ".//div[class=tc-tag]").each_with_index do |div, i|
          expect(div[:'data-text']).to eql(ordered_tags[i])
        end
      end
    end
    
    def change_tags(tags)
      tags.each do |name,type|
        xpath = ".//div[@data-text='#{name}']"
        
        within(:xpath, xpath) do
          find('.action #link').click
        end
        choose "type_#{type}"
      end
      click_button "Map" # save
    end
    
    def click_type(type)
      sleep(5)
      find(@type).click
      sleep(5)
    end

    it "should create tags", :skip => true do
      create_tags @type, @tags
    end

    it "should prefill tags" do
      create_tags @type, @tags
      click_type @type
      validate_tags @tags
    end

    it "should validate delete tags", focus: true do
      create_tags @type, @tags
      click_type @type
      
      delete_tags(@tags_to_delete)
      @tags -= @tags_to_delete
      validate_skull_tags @type, @tags
      
      click_type @type
      validate_tags @tags
    end

    it "should allow to change tags and validate change" do
      create_tags @type, @tags
      click_type @type
      
      tags = [%w(Angry When), %w(Happy Who), ["feeling ok", "Where"]]
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
