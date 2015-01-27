class AddQuestionCountToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys,:question_count, :integer
  end
end
