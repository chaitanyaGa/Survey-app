class Changecolumnnametype < ActiveRecord::Migration
  def change
    rename_column :surveys,:type,:type_of_survey
  end
end
