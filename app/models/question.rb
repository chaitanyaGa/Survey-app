class Question < ActiveRecord::Base

  # associations
  belongs_to :survey
  has_many :options


  # callbacks
  after_create :modify_count
  after_destroy :modify_count

  def modify_count
    puts "increase count of survey"
    questions_count = self.survey.questions.count
    self.survey.update_attributes(question_count: questions_count)
  end

end
