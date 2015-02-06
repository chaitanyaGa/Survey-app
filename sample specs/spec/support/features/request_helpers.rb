require 'spec_helper'
include Warden::Test::Helpers

module Features
  module RequestHelpers
    def create_logged_in_user
      user = create(:user)
      login(user)
      user
    end

    def login(user)
      login_as user, scope: :user
    end
  end
end
