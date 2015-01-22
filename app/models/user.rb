class User < ActiveRecord::Base
  belongs_to :role
  has_many :options, through: :respnse
end
