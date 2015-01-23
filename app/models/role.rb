class Role < ActiveRecord::Base
  has_many :users, dependant :destroy
end
