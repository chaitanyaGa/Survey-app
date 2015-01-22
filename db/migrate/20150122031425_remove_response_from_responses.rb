class RemoveResponseFromResponses < ActiveRecord::Migration
  def change
    remove_column :responses, :response, :integer
  end
end
