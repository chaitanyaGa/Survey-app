def set_omniauth(opts = {})
  default = {:provider => :facebook,
             :uuid     => "1234",
             :facebook => {
               :email => "test@gmail.com",
               :gender => "male",
               :first_name => "test",
               :last_name => "user",
               :image => 'http://graph.facebook.com/659307629/picture?type=square'
             }
  }

  credentials = default.merge(opts)
  provider = credentials[:provider]
  user_hash = credentials[provider]

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[provider] = {
    'uid' => credentials[:uuid],
    'provider' => 'facebook',
    "info" => {
      "email" => user_hash[:email],
      "name" => user_hash[:first_name],
      "image" => user_hash[:image],
      "gender" => user_hash[:gender]
    }
  }
end

def set_invalid_omniauth(opts = {})

  credentials = { :provider => :facebook,
                  :invalid  => :invalid_crendentials
  }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]

end
