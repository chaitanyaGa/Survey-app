require 'spec_helper'

describe 'Playbook', :js => true, driver: :selenium do
  before(:each) do
    @user = create_logged_in_user
  end


  it 'add v2 star badge if user points are more than 2000' do
    point = Merit::Score::Point.new
    point.target_created_at = Date.today
    point.num_points = 1980
    point.score_id = 1
    point.save
    attrs = {name: 'Playbook', show_third_level: true, level_1: {magnitude: 5, unit: '5'}, level_2: {magnitude: 4, unit: '2'}, level_3: {unit: '3'}, reminder_times: {formatted_time: '04:30 PM +0530 (Chennai)', repeat: true, enabled: true, days_of_week: ['Mon', 'Wed', 'Fri']}}
    create_playbook(attrs)
    check_points_and_badges(2000, 1)

    visit_playbook_form(attrs)
    find('.delete').click
    accept_alert
    #flash_message('deleted')
    expected_container_count(1)
    check_points_and_badges(1980, '')

    puts NewPlan.unscoped.inspect
    attrs = {name: 'Playbook', level_1: {magnitude: 5, unit: '1'}, level_2: {magnitude: 4, unit: '1'}, reminder_times: {formatted_time: '04:30 PM +0530 (Chennai)', repeat: true, enabled: true, days_of_week: ['Mon', 'Wed', 'Fri']}}
    create_playbook(attrs)
    check_points_and_badges(2030, 1)

    visit_playbook_form(attrs)
    find('.delete').click
    accept_alert
    #flash_message('deleted')
    expected_container_count(1)
    check_points_and_badges(1980, '')
  end

  ###############################################- METHODS ###############################################################
  def check_points_and_badges(points_count, badges_count)
    page.should have_css('#points', :text => points_count)
    if badges_count.present?
      page.should have_css('#gold_badge_count', :text => badges_count)
    else
      page.should_not have_css('#gold_badge_count')
    end
  end

  def expected_container_count(num)
    expect(page).to have_css('.u_container', :count => num)
  end

  def expect_container_with_plan_name(attrs) 
    expect(page).to have_css('.u_container .u3_normal', text: attrs[:name])
  end

end
