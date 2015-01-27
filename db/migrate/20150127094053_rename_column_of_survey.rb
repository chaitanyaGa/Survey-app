class RenameColumnOfSurvey < ActiveRecord::Migration
  def change
    rename_column :surveys , :no_of_peaople, :no_of_people
  end
end
