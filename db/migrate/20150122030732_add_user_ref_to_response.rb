class AddUserRefToResponse < ActiveRecord::Migration
  def change
    add_reference :responses, :users, index: true
    change_column :responses, :users_id, :integer, :null => false
  end
end
