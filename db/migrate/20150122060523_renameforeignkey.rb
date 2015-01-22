class Renameforeignkey < ActiveRecord::Migration
  def change
    rename_column :options, :questions_id, :question_id
    rename_column :questions, :surveys_id,:survey_id
    rename_column :responses, :users_id, :user_id 
    rename_column :responses, :options_id, :option_id
    rename_column :users, :roles_id, :role_id

  end
end
