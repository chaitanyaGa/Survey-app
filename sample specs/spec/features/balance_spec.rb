require 'spec_helper'

describe "Balance", :js => true, :driver => :selenium do
  before(:each) do
    create_logged_in_user
  end

  def visit_balance_path
    visit balances_path
  end

  def click_new_balance
    expect(page).to have_css('.new_map', :text => "new balance")
    find('.new_map').click
    expect(page).to have_content("Balance")
    expect(page).not_to have_content("All Balances")
  end

  def clear_tags(question_id)
    within("[data-id=#{question_id}]") do
      within(".bootstrap-tagsinput") do
        all('.label').each do |tag|
          tag.find("[data-role='remove']").click
        end
      end
    end
  end

  def add_tags(question_id, tags)
    within("[data-id=#{question_id}]") do
      within(".bootstrap-tagsinput") do
        tags.each do |tag|
          case Capybara.current_driver
          when :webkit
            find('input').set("#{tag}\n")
          when :selenium
            find('input').set(tag)
            find('input').native.send_keys(:return)
          end
        end #tags
      end #within
    end #within
  end

  def fillin_balance(attrs)

    expect(page).to have_selector('[data-id=tag]')
    find('[data-id=tag]').set(attrs[:tag]) if attrs[:tag]

    attrs[:items].each do |question_id, tags|
      unless [:this_triggers, :what_changes].include? question_id
        clear_tags question_id
        add_tags question_id, tags
      end
    end if attrs[:items]

    expect(page).to have_selector('button', :text => "Save & Continue")
    click_button "Save & Continue"
  end

  def create_bundle
    visit_balance_path
    expect(page).to have_css(".u_container", :count => 1)
    click_new_balance
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'Party', items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } })
    #accept_alert
    expect(page).to have_css(".u_container", :count => 2)

    click_new_balance
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'Study', items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } })
    #accept_alert
    expect(page).to have_css(".u_container", :count => 3)

    click_new_balance
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'Trekk', items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } })
    #accept_alert
    expect(page).to have_css(".u_container", :count => 4)

  end

  def check_content(attrs)
    attrs[:items].each do |question_id, tags|
      unless [:this_triggers, :what_changes, :what_actions].include? question_id
        within("[data-id=#{question_id}]") do
          within(".bootstrap-tagsinput") do
            expect('span.tag').not_to have_content(tags)
          end
        end
      end
    end
  end

  def click_balance(str)
    find(".u_container .u3_normal p", text: str).click
  end

  def visit_balance_index
    within(".btn-group.pull-right") do
      click_link "Balances"
    end
  end

  def select_opt(number)
    find('[data-id="entry_item_type"]').find(:xpath, 'option['+number+']').select_option
  end

  it "should able to create new balance and load same on listing" do
    visit_balance_path
    expect(page).to have_css(".u_container", :count => 1)
    click_new_balance
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'A', items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } })
    #accept_alert
    expect(page).to have_css(".u_container", :count => 2)
  end

  it "should allow editing of balance" do
    create_bundle
    #find(".u_container .u3_normal >p", :text => 'Study').find(:xpath, '../../..').click
    find(".u_container .u3_normal >p", :text => 'Study').click
    sleep(1)
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'Study11', items: {main_reason: %w(A B), believe_yes: %w(believe1 believe2), believe_no: %w(believen1 believen2), belief_reframe: %w(d e f), this_triggers: %w(x y z), what_actions: %w(l m n) } })
    #accept_alert
    expect(page).to have_css(".u_container", :count => 4)
    expect(page).to have_css(".u_container", text: 'Study11')
    #expect(page).not_to have_css(".u_container", text: /\AStudy\z/)
  end

  it "should list balances" do
    create_bundle
    visit_micro_view
    visit_balance_path
    expect(page).to have_css(".u_container", :count => 4)
  end

  it "should able to delete balance" do
    create_bundle
    balance = find(".u_container", text: 'Study')
    balance.hover
    balance.find('.delete').click
    accept_alert
    accept_alert
    expect(page).to have_css(".u_container", :count => 3)
    expect(page).not_to have_css(".u_container", text: 'Study')
    #expect(page).not_to have_css(".u_container", text: /\AStudy\z/)
  end

  it "should able to balance from analytics" do
    visit balances_path(anchor: 'new/tag/A')
    sleep(1)
    #select emotions type
    select_opt('1')
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'A', items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } })
    expect(page).to have_css(".u_container", :count => 2)
  end

  it "should able to create all three type of balance and load same on listing", focus: true do
    visit_balance_path
    str = 'Emotion Tag'
    click_new_balance
    find('#default-section-link').click
    find('#playbook-section-link').click
    attrs = { tag: str, items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } }
    fillin_balance(attrs)
    click_balance(str)
    find('#default-section-link').click
    find('#playbook-section-link').click
    check_content(attrs)
    visit_balance_index


    str = 'Behavior Tag'
    click_new_balance
    select_opt('1')
    find('#new-section-link').click
    find('#this_implies').click
    attrs = { tag: str, items: {resistance: %w(Resistance), this_implies: %w(This Implies), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t)}}
    fillin_balance(attrs)
    click_balance(str)
    find('#new-section-link').click
    check_content(attrs)
    visit_balance_index


    attrs = { items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_implies: %w(x y z), what_changes: %w(p q r) }}
    click_balance(str)
    find('[data-tab="default"]').click
    find('#this_implies').click
    fillin_balance(attrs)
    click_balance(str)
    find('[data-tab="default"]').click
    check_content(attrs)
    visit_balance_index


    attrs = { items: {this_triggers: %w(x y z), what_actions: %w(p q r) } }
    click_balance(str)
    find('[data-tab="playbook"]').click
    fillin_balance(attrs)
    click_balance(str)
    find('[data-tab="playbook"]').click
    check_content(attrs)
    visit_balance_index

    str = 'Desire Tag'
    attrs = { tag: str, items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_implies: %w(x y z), what_changes: %w(p q r), this_triggers: %w(x y z), what_actions: %w(p q r) } }
    click_new_balance
    select_opt('3')
    find('[data-tab="default"]').click
    find('#playbook-section-link').click
    find('#this_implies').click
    fillin_balance(attrs)
    click_balance(str)
    find('[data-tab="default"]').click
    check_content(attrs)
    visit_balance_index

  end

  it "should assign 100 point for adding balance" do
    visit_balance_path
    expect(page).to have_css(".u_container", :count => 1)
    click_new_balance
    find('#default-section-link').click
    find('#playbook-section-link').click
    fillin_balance( { tag: 'A', items: {main_reason: %w(A B), believe_yes: %w(C D), believe_no: %w(E F), belief_reframe: %w(r t), this_triggers: %w(x y z), what_actions: %w(p q r) } })
    #accept_alert
    expect(page).to have_css(".u_container", :count => 2)
    page.should have_css('#points', :text => '100')
    page.should have_css('#bronze_badge_count', :text => '1')
  end
end
