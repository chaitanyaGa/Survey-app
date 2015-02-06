# generate code coverage when tests run
require 'simplecov'
SimpleCov.start 'rails'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'email_spec'
require 'rspec/autorun'
require 'factory_girl'
require 'rake'
require 'capybara/email/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|


  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  
  config.include FactoryGirl::Syntax::Methods
  config.include Features::SessionHelpers, type: :feature
  config.include Features::MapHelpers, type: :feature
  config.include Features::JournalHelpers, type: :feature
  config.include Features::PlaybookHelpers, type: :feature
  config.include Features::ReminderHelpers, type: :feature
  config.include Features::RequestHelpers, type: :feature
  config.filter_run_excluding :skip => true

  config.before(:suite) do
    #Capybara.javascript_driver = :selenium
    Capybara.javascript_driver = :webkit
    Capybara.default_wait_time = 5
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    load File.join(Rails.root, 'Rakefile')
    #Rake::Task["db:data:load"].invoke
    Rake::Task["db:seed"].invoke
  end

  config.before(:each, :js => true) do
    except = %w(map_item_types emotion_types circumstance_types need_types underlying_needs 
               underlying_beliefs thinking_styles behavior_labels
               checkin_item_types checkin_item_question_types entry_item_tag_types
               entry_rating_types entry_item_types system_entry_item_types system_entry_rating_types
               user_entry_item_types user_entry_rating_types assessment_areas assessment_questions
              )
    DatabaseCleaner.strategy = :truncation, {:except => except }
    maximize_window
  end
  
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"


  config.include ShowMeTheCookies, :type => :feature

end
