class AddForeignKey < ActiveRecord::Migration
  def change
    add_reference :users, :roles
    change_column :users, :roles_id,:integer, :null => false
  end
end
