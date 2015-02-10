class Survey < ActiveRecord::Base
  TYPES = ['event','general','sports']
  has_many :questions, dependent: :destroy
  validates_numericality_of :question_count,:only_integer => true
#  after_create :titeleize if :question
  validates :name, presence: true
  
end
