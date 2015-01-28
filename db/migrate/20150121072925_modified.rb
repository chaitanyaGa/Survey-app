class Modified < ActiveRecord::Migration
  def change
    add_column :surveys,:no_of_people,:integer
  end
end
