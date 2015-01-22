class Modified < ActiveRecord::Migration
  def change
    add_column :surveys,:no_of_peaople,:integer
  end
end
