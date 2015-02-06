require 'spec_helper'

describe "User Tags", :js => true, driver: :selenium do
  context 'Show All tags of a user' do
    before(:each) do
      user1 = create(:user, name: 'first')
      user2 = create(:user, name: 'second')
      @user1_tags =  create_tags_for_user(user1)
      @user2_tags =  create_tags_for_user(user2)
      sign_in user1
    end
    it 'should be visible on episode page' do
      visit root_path
      visit_micro_view
      within(".new-episode") do
        find('.icon-edit').click
      end

      @user1_tags.each do |type, tags|
        next if type == 'Action'
        within(".bent_tags_cloud.#{type.downcase}") do
          all('.bootstrap-tagsinput input').first.click
          all('.bootstrap-tagsinput input').first.click
          expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(tags)
          expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags[type])
        end 
      end
    end

    it 'should be visible on playbook page' do
      visit_playbook
      goto_new_playbook_form
      find('#plan_of_type').set(true)
      all('#context_inputs .bootstrap-tagsinput input').first.click
      all('#context_inputs .bootstrap-tagsinput input').first.click
      tags1 = @user1_tags.collect do |type, tags|
        type_name = type == 'what' ? 'Circumstance' : type.singularize
        tags.collect{|t| "#{t} [#{type_name}]"}
      end.flatten
      tags2 = @user2_tags.collect do |type, tags|
        type_name = type == 'what' ? 'Circumstance' : type.singularize
        tags.collect{|t| "#{t} [#{type_name}]"}
      end.flatten
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(tags1)
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(tags2)
    end

    it 'should be visible on assessment page' do
      visit journal_path(anchor: "assessment")
      expect(page).to have_content('Assessment')
      sleep(10)
      within('.new-assessment') do
        all('.section-link')[0].click
        all('.bootstrap-tagsinput input')[0].double_click
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(@user1_tags['wants'])
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags['wants'])
        find('.purple.div-narrow').click
        all('.bootstrap-tagsinput input')[2].double_click
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(@user1_tags['emotions'])
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags['emotions'])
        find('.purple.div-narrow').click
        all('.bootstrap-tagsinput input')[4].double_click
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(@user1_tags['behaviors'])
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags['behaviors'])
      end
    end
  end

  it 'All tags should be visible on balance page' do
    user1 = create(:user, name: 'first')
    user2 = create(:user, name: 'second')
    @user1_tags =  create_tags_for_user(user1, false)
    @user2_tags =  create_tags_for_user(user2, false)
    sign_in user1
    visit balances_path
    expect(page).to have_css('.new_map', :text => "new balance")
    find('.new_map').click
    {'emotions' => '2', 'behaviors' => '1', 'desires' => '3'}.each  do |name, num|
      type = EntryItemType.find_by_name name
      opt =  'option['+num+']'
      find('#type_select').find(:xpath, opt).select_option
      find('.main-balance input').click
      find('.main-balance input').click
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(@user1_tags[type.identifier])
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags[type.identifier])
    end
  end

  # Balance tags are not created when visiting balance page, because it crash balance page when assigning tags to input field on balance page.
  def create_tags_for_user(user, create_balance_items=true)
    emotion_type = EntryItemType.find_by_name 'emotions'
    emotion_tag = EntryItemTag.find_or_create_by_name name: "emotion-balance-#{user.name}"
    balance = create(:balance, user: user, entry_item_type: emotion_type, entry_item_tag: emotion_tag)
    
    playbook = build(:new_plan, user: user)
    playbook.save(validate: false)
    assessment = user.assessments.create!({assessment_area_id: 1})
    entry = create(:entry, user: user)
    tags = {}
    EntryItemType.all.each do |type|
      next if type.name == "Actions"
      tag_name = "#{type.name}-#{user.name}"
      balance_tag = EntryItemTag.find_or_create_by_name("#{tag_name}-balance") if create_balance_items
      playbook_tag = EntryItemTag.find_or_create_by_name("#{tag_name}-playbook")
      assessment_tag = EntryItemTag.find_or_create_by_name("#{tag_name}-assessment")
      entry_tag = EntryItemTag.find_or_create_by_name("#{tag_name}-episode")
      tags[type.identifier] = [playbook_tag.name, assessment_tag.name, balance_tag.try(:name), entry_tag.name].compact

      balance.balance_items.create(entry_item_type_id: type.id, entry_item_tag_id: balance_tag.id, section: 'default', question_id: 'main_reason') if create_balance_items
      playbook.new_plan_items.create(name: "#{tag_name}-playbook [#{type.name}]")
      assessment.assessment_items.create(entry_item_type_id: type.id, entry_item_tag_id: assessment_tag.id)
      entry.entry_items.create(entry_item_type_id: type.id, entry_item_tag_id: entry_tag.id)
    end
    tags['emotions'] << emotion_tag.name
    tags
  end
  
  context 'Reload tags after save' do
    before(:each) do
      user1 = create(:user, name: 'first')
      user2 = create(:user, name: 'second')
      @user1_tags =  create_tags_for_user(user1)
      @user2_tags =  create_tags_for_user(user2)
      sign_in user1
    end
    
    it 'should reload tags on episode save' do
      visit_micro_view
      within(".new-episode") do
        find('.icon-edit').click
      end

      # Add 'who' type input ,save episode and check it load on other episode
      within('.bent_tags_cloud.who') do
        within('.bootstrap-tagsinput') do
          find('input').set('another-who')
        end
      end
      click_link "Save & Close"
      sleep(1)

      within(".new-episode") do
        find('.icon-edit').click
      end

      @user1_tags['what'] << 'Misc.'
      @user1_tags['who']  << 'another-who'
      @user1_tags.each do |type, tags|
        next if type == 'Action'
        within(".bent_tags_cloud.#{type.downcase}") do
          all('.bootstrap-tagsinput input').first.click
          all('.bootstrap-tagsinput input').first.click
          expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(tags)
          expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags[type])
        end 
      end
    end

    it 'should reload tags on playbook save' do
      visit_playbook
      goto_new_playbook_form
      # create new context playbook with 'anger' context
      find('#plan_name').set('Playbook')
      find('#plan_of_type').set(true)
      within('#context_inputs') do
        find('input').set('anger')
      end
      find('#plan_checkin_period').find(:xpath, 'option[1]').select_option
      sleep(1)
      click_button "Save Playbook"
      sleep(1)

      # Add context name to user_tags
      @user1_tags['what'] << 'anger'
      
      # check if new playbook include 'anger' tag
      goto_new_playbook_form
      find('#plan_of_type').set(true)
      all('#context_inputs .bootstrap-tagsinput input').first.click
      all('#context_inputs .bootstrap-tagsinput input').first.click
      tags1 = @user1_tags.collect do |type, tags|
        type_name = type == 'what' ? 'Circumstance' : type.singularize
        tags.collect{|t| "#{t} [#{type_name}]"}
      end.flatten
      tags2 = @user2_tags.collect do |type, tags|
        type_name = type == 'what' ? 'Circumstance' : type.singularize
        tags.collect{|t| "#{t} [#{type_name}]"}
      end.flatten
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(tags1)
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(tags2)
    end

    it 'should reload tags on assessment save' do
      visit journal_path(anchor: "assessment")
      expect(page).to have_content('Assessment')
      sleep(5)
      within('.new-assessment') do
        all('.section-link')[0].click
        # Add new assessment tag
        all('.bootstrap-tagsinput input').first.set('new-assessment')
        # Add value to hidden field
        page.execute_script("$('.tags:first').val('new-assessment')")
        click_button 'Save'
        sleep(10)

        # add new-assessment tag to user_tags
        @user1_tags['wants'].delete("Desires-first-assessment")
        @user1_tags['wants'] << 'new-assessment'

        # check if new-assessment tag loaded
        all('.bootstrap-tagsinput input')[0].click
        all('.bootstrap-tagsinput input')[0].click
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(@user1_tags['wants'])
        expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags['wants'])
      end
    end

  end
  
  it 'All tags should reloaded on balance save' do
    user1 = create(:user, name: 'first')
    user2 = create(:user, name: 'second')
    @user1_tags =  create_tags_for_user(user1, false)
    @user2_tags =  create_tags_for_user(user2, false)
    sign_in user1
    visit balances_path

    # add new balance
    find('.new_map').click
    find('#type_select').find(:xpath, 'option[1]').select_option
    find('.main-balance input').set('test balance')
    click_button 'Save & Continue'
    sleep(2)

    # add tag to user1_tags
    @user1_tags['behaviors'] << 'test balance'

    # check if new tag get reloaded
    find('.new_map').click
    #expect(page).to have_css('.new_map', :text => "new balance")
    {'emotions' => '2', 'behaviors' => '1', 'desires' => '3'}.each  do |name, num|
      type = EntryItemType.find_by_name name
      opt =  'option['+num+']'
      find('#type_select').find(:xpath, opt).select_option
      find('.main-balance input').click
      find('.main-balance input').click
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).to match_array(@user1_tags[type.identifier])
      expect(all(".typeahead li").map { |li| li[:'data-value'] }).not_to match_array(@user2_tags[type.identifier])
    end
  end
end
