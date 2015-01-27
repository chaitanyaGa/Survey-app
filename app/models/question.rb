class Question < ActiveRecord::Base
  belongs_to :survey
  has_many :options

  after_create :increase_count

  after_destroy :increase_count

  def increase_count
    puts "increase count of survey"
    questions_count = self.survey.questions.count
    self.survey.update_attributes(question_count: questions_count)
  end

end
