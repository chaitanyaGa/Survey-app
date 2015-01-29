class Survey < ActiveRecord::Base
  TYPES = ['event','general']
  has_many :questions
#  after_create :titeleize if :question
  
end
