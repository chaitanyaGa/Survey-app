# spec/features/session_helpers.rb
module Features
  module SessionHelpers
    def sign_up
      visit new_user_registration_path
      within("#new_user") do
        fill_in 'user_email', :with => "test@happiness.com"
        fill_in 'user_password', :with => "please"
        fill_in 'user_password_confirmation', :with => "please"
        check 'user_terms_of_service'
      end
      click_button 'Sign up'
      expect(page).to have_css('.alert')
      expect(page).to have_content("Welcome! You have signed up successfully.")
    end

    def sign_out
      visit destroy_user_session_path
      within(".alert") do
        page.should have_content("Signed out successfully.")
      end
    end

    def sign_in(options = {})
      visit new_user_session_path
      
      email = options[:email] || 'test@happiness.com'
      password = options[:password] || 'please'

      within("#new_user") do
        fill_in 'user_email', :with => email
        fill_in 'user_password', :with => password
      end

      click_button 'Sign in'

      within("#flash .alert") do
        page.should have_content("Signed in successfully.")
      end
    end

    def handle_js_confirm(accept=true)
      page.evaluate_script "window.original_confirm_function = window.confirm"
      page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
      yield
    ensure
      page.evaluate_script "window.confirm = window.original_confirm_function"
    end

    def accept_alert
      case Capybara.current_driver
      when :selenium
        page.driver.browser.switch_to.alert.accept
      when :webkit
        handle_js_confirm {}
      end
    end
    
    def maximize_window
      page.driver.browser.manage.window.maximize if Capybara.current_driver == :selenium
    end
  end
end
