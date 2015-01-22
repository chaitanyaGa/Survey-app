class AddOptionRefResponse < ActiveRecord::Migration
  def change
    add_reference :responses, :options, index: true
    change_column :responses, :options_id, :integer, :null => false
  end
end
