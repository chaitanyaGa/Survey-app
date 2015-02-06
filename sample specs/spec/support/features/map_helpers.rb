# spec/support/features/map_helpers.rb
module Features
  module MapHelpers
    def create_map(title)
      visit bent_path
      find('.new_map').click
      fill_in 'map_title', :with => title
      click_link 'map_save'
    end

    def delete_map(title)
      within('.container-fluid') do
        map = find(".u_container .u3_normal >p", :text => title).find(:xpath, '../../..')
        map.hover
        map.find(".delete").click
        handle_js_confirm {}
        handle_js_confirm {}
      end
    end

    def show_map(title)
      visit bent_path
      within('.container-fluid') do
        find(".u_container .u3_normal > p", :text => title).click
      end
    end
    
    def create_tags(type, tags)
      click_type type
      within('.bent_form') do
        tags.each do |tag|
          fill_in "tags", :with => "#{tag}\t"
        end
      end
      click_button "Map" #save
    end

    def delete_tags(tags)
      tags.each do |tag|
        xpath = ".//div[@data-text='#{tag}']"
        
        within(:xpath, xpath) do
          find(".tm-tag a").click
        end
      end
      click_button "Map" # save
    end
    
    def validate_tags(tags)
      tags.each do |name|
        xpath = ".//div[@data-text='#{name}']"

        within(:xpath, xpath) do
          find("span", :text => name)
        end
      end
    end
    
    def validate_skull_tags(type, tags)
      sleep(2)
      within(".#{type.singularize.downcase} .tag-box") do
        all(:xpath, ".//a").each do |a|
          text = a.text
          tag,* = tags.reverse.detect {|name,*| text == name }
          expect(tag).to eql(text)
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
    
    def prefill_map(title, type, prefill)
      create_map title
      show_map title
      
      click_type(type)
      within('.bent_form') do
        prefill.each do |name|
          fill_in "tags", :with => "#{name}\t"
        end
      end
      click_button "Map"
    end
    
    def validate_typeahead(type, text, typeahead)
      show_map "Typeahead-Test-Map"
      click_type(type)
      within('.bent_form') do
        fill_in "tags", :with => text
        sleep(2) # possibly typeahead may take some time to show up
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).to eql(typeahead)
      end
    end

    def click_type(type)
      sleep(5)
      if type == "#circumstance"
        find(type).click
      else
        click_link type
      end
      sleep(5)
    end
  end
end
