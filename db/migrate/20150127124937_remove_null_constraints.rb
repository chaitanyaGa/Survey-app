class RemoveNullConstraints < ActiveRecord::Migration
  def change
    change_column :users, :role_id, :integer, :null => true
  end
end
