class Survey < ActiveRecord::Base

  has_many :questions
#  after_create :titeleize if :question
  
end
