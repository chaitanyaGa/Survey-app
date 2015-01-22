class AddSurveyRefToQuestion < ActiveRecord::Migration
  def change
    add_reference :questions,:surveys ,index: true
    change_column :questions,:surveys_id,:integer,:null => false
  end
end
