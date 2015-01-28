class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.string :type_of_survey
      t.date :conducted
      t.timestamps null: false
    end
  end
end
